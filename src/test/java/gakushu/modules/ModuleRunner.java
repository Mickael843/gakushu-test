package gakushu.modules;

import com.intuit.karate.junit5.Karate;

public class ModuleRunner {

    @Karate.Test
    Karate moduleTest() {
        return Karate.run().relativeTo(getClass());
    }
}
