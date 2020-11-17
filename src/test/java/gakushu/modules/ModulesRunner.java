package gakushu.modules;

import com.intuit.karate.junit5.Karate;

public class ModulesRunner {

    @Karate.Test
    Karate testModules() {
        return Karate.run("modules-creation").relativeTo(getClass());
    }
}
