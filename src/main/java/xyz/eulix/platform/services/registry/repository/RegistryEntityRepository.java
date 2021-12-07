package xyz.eulix.platform.services.registry.repository;

import io.quarkus.hibernate.orm.panache.PanacheQuery;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import xyz.eulix.platform.services.registry.entity.RegistryEntity;

import javax.enterprise.context.ApplicationScoped;
import java.util.List;
import java.util.Optional;

/**
 * All Registry Entity related storage operations including standard CRUD and
 * other customized operations such as state transition and updating.
 */
@ApplicationScoped
public class RegistryEntityRepository implements PanacheRepository<RegistryEntity> {
    // 根据box_uuid、box_reg_key、type查询资源
    private static final String FIND_BY_BOXUUID_BOXREGKEY_TYPE = "box_uuid=?1 AND box_reg_key=?2 AND type=?3";

    // 根据box_uuid、user_id、client_uuid、box_reg_key查询资源
    private static final String FIND_BY_CLIENTUUID_CLIENTREGKEY = "box_uuid=?1 AND user_id=?2 AND client_uuid=?3 AND client_reg_key=?4";

    // 根据box_uuid、user_id、client_uuid查询资源
    private static final String FIND_BY_CLIENTUUID = "box_uuid=?1 AND user_id=?2 AND client_uuid=?3";

    // 根据box_uuid、type查询资源
    private static final String FIND_BY_BOXUUID_TYPE = "box_uuid=?1 AND type=?2";

    // 根据box_uuid、type查询资源
    private static final String FIND_BY_USERDOMAIN = "user_domain=?1";

    // 根据box_uuid、user_id查询资源
    private static final String FIND_BY_BOXUUID_USERID = "box_uuid=?1 AND user_id=?2";;

    // 根据box_uuid、user_id、user_reg_key查询资源
    private static final String FIND_BY_BOXUUID_USERID_USERREGKEY = "box_uuid=?1 AND user_id=?2 AND user_reg_key=?3";;

    // 根据box_uuid、user_id、client_uuid查询资源
    private static final String FIND_BY_BOXUUID_USERID_CLIENTUUID = "box_uuid=?1 AND user_id=?2 AND client_uuid=?3";;

    public PanacheQuery<RegistryEntity> findByBoxUUIDAndType(String boxUUID, String type) {
        return this.find(FIND_BY_BOXUUID_TYPE, boxUUID, type);
    }

    public PanacheQuery<RegistryEntity> findByBoxUUIDAndBoxRegKeyAndType(String boxUUID, String boxRegKey, String type) {
        return this.find(FIND_BY_BOXUUID_BOXREGKEY_TYPE, boxUUID, boxRegKey, type);
    }

    public List<RegistryEntity> findAllByUserId(String boxUUID, String userId) {
        return this.find(FIND_BY_BOXUUID_USERID, boxUUID, userId).list();
    }

    public List<RegistryEntity> findAllByUserIDAndUserRegKey(String boxUUID, String userId, String userRegKey) {
        return this.find(FIND_BY_BOXUUID_USERID_USERREGKEY, boxUUID, userId, userRegKey).list();
    }

    public List<RegistryEntity> findAllByClientUUID(String boxUUID, String userId, String clientUUID) {
        return this.find(FIND_BY_BOXUUID_USERID_CLIENTUUID, boxUUID, userId, clientUUID).list();
    }

    public List<RegistryEntity> findAllByClientUUIDAndClientRegKey(String boxUUID, String userId, String clientUUID, String clientRegKey) {
        return this.find(FIND_BY_CLIENTUUID_CLIENTREGKEY, boxUUID, userId, clientUUID, clientRegKey).list();
    }

    public void deleteByClientUUID(String boxUUID, String userId, String clientUUID) {
        this.delete(FIND_BY_CLIENTUUID, boxUUID, userId, clientUUID);
    }

    public void deleteByUserId(String boxUUID, String userId) {
        this.delete(FIND_BY_BOXUUID_USERID, boxUUID, userId);
    }

    public Optional<RegistryEntity> findByUserDomain(String userDomain) {
        return this.find(FIND_BY_USERDOMAIN, userDomain).singleResultOptional();
    }
}
