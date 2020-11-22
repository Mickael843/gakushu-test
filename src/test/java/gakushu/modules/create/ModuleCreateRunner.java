package gakushu.modules.create;

import com.intuit.karate.junit5.Karate;

public class ModuleCreateRunner {

    @Karate.Test
    Karate testModuleCreate() {
        return Karate.run("module-create").relativeTo(getClass());
    }
}
