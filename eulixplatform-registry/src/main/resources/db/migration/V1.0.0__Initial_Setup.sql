-- Copyright (c) 2022 Institute of Software Chinese Academy of Sciences (ISCAS)
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

CREATE TABLE IF NOT EXISTS box_info (
    id BIGINT NOT NULL AUTO_INCREMENT,
    box_uuid VARCHAR(128) NOT NULL,
    `desc` VARCHAR(128) DEFAULT NULL,
    extra VARCHAR(1024) DEFAULT NULL COMMENT '预留json格式',
    created_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL,
    version INT DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_info_boxid (box_uuid)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS box_registries (
    id BIGINT NOT NULL AUTO_INCREMENT,
    box_uuid VARCHAR(128) NOT NULL,
    box_reg_key VARCHAR(128) NOT NULL COMMENT '盒子注册码',
    network_client_id VARCHAR(128) NOT NULL COMMENT 'network client id',
    network_secret_key VARCHAR(128) DEFAULT NULL COMMENT 'network client访问密钥',
    created_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL,
    version INT DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_boxid (box_uuid),
    UNIQUE KEY uk_clientid (network_client_id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_registries (
    id BIGINT NOT NULL AUTO_INCREMENT,
    box_uuid VARCHAR(128) NOT NULL,
    user_id VARCHAR(128) NOT NULL,
    user_reg_key VARCHAR(128) NOT NULL COMMENT '用户注册码',
    type VARCHAR(128) NOT NULL COMMENT '注册类型,admin/member',
    created_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL,
    version INT DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_boxid_userid (box_uuid, user_id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS client_registries (
    id BIGINT NOT NULL AUTO_INCREMENT,
    box_uuid VARCHAR(128) NOT NULL,
    user_id VARCHAR(128) NOT NULL,
    client_uuid VARCHAR(128) NOT NULL,
    client_reg_key VARCHAR(128) NOT NULL COMMENT '客户端注册码',
    type VARCHAR(128) NOT NULL COMMENT '注册类型,bind/auth',
    created_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL,
    version INT DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_boxid_userid_clientid (box_uuid, user_id, client_uuid)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS subdomain (
    id BIGINT NOT NULL AUTO_INCREMENT,
    box_uuid VARCHAR(128) NOT NULL,
    user_id VARCHAR(128) DEFAULT NULL,
    subdomain VARCHAR(128) NOT NULL COMMENT '子域名',
    user_domain VARCHAR(128) DEFAULT NULL COMMENT '用户域名',
    state INT DEFAULT 0 COMMENT '0-临时;1-已使用',
    created_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL,
    expires_at DATETIME DEFAULT NULL,
    version INT DEFAULT 0,
    PRIMARY KEY (id),
    KEY uk_boxid_userid (box_uuid, user_id),
    UNIQUE KEY uk_subdomain (subdomain)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS network_client_server_route (
    id BIGINT NOT NULL AUTO_INCREMENT,
    network_client_id VARCHAR(128) NOT NULL COMMENT 'network client id',
    network_server_id BIGINT NOT NULL COMMENT 'network server id',
    created_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL,
    version INT DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_net_clientid (network_client_id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS network_server_info (
    id BIGINT NOT NULL AUTO_INCREMENT,
    server_protocol VARCHAR(128) NOT NULL COMMENT 'network server协议',
    server_addr VARCHAR(128) NOT NULL COMMENT 'network server地址',
    server_port INT NOT NULL COMMENT 'network server端口',
    identifier VARCHAR(128) NOT NULL COMMENT 'network server标识符，如ip',
    created_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL,
    state INT DEFAULT 0 COMMENT '0-未启用;1-已上线',
    version INT DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_identifier (identifier)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE network_server_info ADD extra VARCHAR(1024) DEFAULT NULL COMMENT '扩展字段,json格式';

insert ignore into network_server_info (server_protocol, server_addr, server_port, identifier, extra, created_at, updated_at) values ('tls','ts.platform.eulix.xyz','59000','eulixnetwork-server.bp-cicada-rc.svc.cluster.local:80', '{"stun_addr":"stun:stun-ts.platform.eulix.xyz:3478"}', now(), now());

CREATE TABLE IF NOT EXISTS pkey_auth (
    id BIGINT NOT NULL AUTO_INCREMENT,
    pkey VARCHAR(128) NOT NULL,
    bkey VARCHAR(128) DEFAULT NULL,
    user_domain VARCHAR(128) DEFAULT NULL COMMENT '用户域名',
    box_pub_key VARCHAR(1024) DEFAULT NULL COMMENT '盒子公钥',
    created_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL,
    expires_at DATETIME DEFAULT NULL,
    version INT DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_pkey (pkey)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS pkg_info (
    id BIGINT NOT NULL AUTO_INCREMENT,
    pkg_name VARCHAR(128) NOT NULL,
    pkg_type VARCHAR(128) NOT NULL,
    pkg_version VARCHAR(128) NOT NULL,
    pkg_size BIGINT DEFAULT NULL COMMENT '单位字节',
    update_desc TEXT DEFAULT NULL,
    force_update INT DEFAULT 0 COMMENT '1-强制更新;0-可选更新',
    download_url VARCHAR(256) NOT NULL,
    md5 VARCHAR(128) DEFAULT NULL,
    min_compatible_android_version VARCHAR(128) DEFAULT NULL COMMENT '最小android兼容版本',
    min_compatible_ios_version VARCHAR(128) DEFAULT NULL COMMENT '最小ios兼容版本',
    min_compatible_box_version VARCHAR(128) DEFAULT NULL COMMENT '最小box兼容版本',
    extra VARCHAR(1024) DEFAULT NULL COMMENT '预留json格式',
    created_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL,
    version INT DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_pkg_name_type_version (pkg_name,pkg_type,pkg_version)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS proposal (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_domain VARCHAR(128) DEFAULT NULL COMMENT '用户域名',
    content VARCHAR(1024) NOT NULL COMMENT '反馈内容',
    email VARCHAR(128) DEFAULT NULL,
    phone_number VARCHAR(128) DEFAULT NULL,
    image_urls VARCHAR(1024) DEFAULT NULL COMMENT '图片地址',
    created_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL,
    version INT DEFAULT 0,
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS questionnaire (
    id BIGINT NOT NULL AUTO_INCREMENT,
    title VARCHAR(1024) NOT NULL COMMENT '标题',
    content VARCHAR(1024) NOT NULL COMMENT '内容(地址)',
    start_at DATETIME DEFAULT NULL COMMENT '开始日期',
    end_at DATETIME DEFAULT NULL COMMENT '结束日期',
    payload_survey_id BIGINT NOT NULL COMMENT '第三方问卷id',
    created_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL,
    version INT DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_payload_survey_id (payload_survey_id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS questionnaire_feedback (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_domain VARCHAR(128) NOT NULL COMMENT '用户域名',
    payload_survey_id BIGINT NOT NULL COMMENT '第三方问卷id',
    payload_answer_id BIGINT NOT NULL COMMENT '第三方问卷答案id',
    payload_answer_at DATETIME DEFAULT NULL COMMENT '用户提交答案时间',
    payload_answer_detail TEXT DEFAULT NULL COMMENT '用户答案详情,json格式',
    extra VARCHAR(1024) DEFAULT NULL COMMENT '预留json格式',
    created_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL,
    version INT DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_userdomain_payload_answer_id (user_domain, payload_survey_id, payload_answer_id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;