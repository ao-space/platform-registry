package xyz.eulix.platform.services.registry.dto.registry;

import lombok.Data;
import org.eclipse.microprofile.openapi.annotations.media.Schema;

import javax.validation.constraints.NotBlank;

/**
 * Used to define a data transfer object as REST request for holding related parameters
 * of registry information.
 */
@Data
public class BoxInfo {
    @NotBlank
    @Schema(description = "盒子的 UUID")
    private String boxUUID;

    @Schema(description = "盒子的描述信息")
    private String desc;

    @Schema(description = "盒子的扩展信息,json格式")
    private Object extra;
}