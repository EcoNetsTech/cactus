package io.github.ximutech.cactus.test;

import io.github.ximutech.cactus.CactusGenerator;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(classes = TestApplication.class)
public class GeneratorTests {

    @Autowired
    private CactusGenerator cactusGenerator;

    @Test
    public void test(){
        cactusGenerator.execute();
    }
}
