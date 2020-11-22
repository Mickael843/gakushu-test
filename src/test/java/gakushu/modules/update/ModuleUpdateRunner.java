package gakushu.modules.update;

import com.intuit.karate.junit5.Karate;

public class ModuleUpdateRunner {

    @Karate.Test
    Karate testModuleUpdate() {
        return Karate.run("module-update").relativeTo(getClass());
    }
}
