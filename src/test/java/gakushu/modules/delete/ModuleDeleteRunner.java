package gakushu.modules.delete;

import com.intuit.karate.junit5.Karate;

public class ModuleDeleteRunner {

    @Karate.Test
    Karate testModuleUpdate() {
        return Karate.run("module-delete").relativeTo(getClass());
    }
}
