package io.github.ximutech.cactus.test;

import io.github.ximutech.cactus.CactusGenerator;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(classes = TestApplication.class)
public class GeneratorTests {

    @Test
    public void test(){
        CactusGenerator generator = new CactusGenerator();
        generator.execute();
    }
}
