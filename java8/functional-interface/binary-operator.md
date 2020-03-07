在Java8中[BinaryOperator](https://docs.oracle.com/javase/8/docs/api/java/util/function/BinaryOperator.html)是一个函数式接口，它继承自[BiFunction](bi-function.md)。

BinaryOperator可以接受两个类型为T的参数，返回一个类型为T的结果。

**BinaryOperator.java**
```java
@FunctionalInterface
public interface BinaryOperator<T> extends BiFunction<T,T,T> {
}
```

相比之下，BiFunction则可以接受两个任意类型的参数，返回一个任意类型的结果。

**BiFunction.java**
```java
@FunctionalInterface
public interface BiFunction<T, U, R> {
      R apply(T t, U u);
}
```

## 实例1：使用BinaryOperator替换BiFunction

当BiFunction的两个参数类型与返回值类型都是同一类型的时候，我们可以使用BinaryOperator替换BiFunction，比如可以用`BinaryOperator<Integer>`替换`BiFunction<Integer, Integer, Integer>`。

下面这个例子用于计算x1+x2：

**Java8BinaryOperator1.java**

```java
package cc.myexample;

import java.util.function.BiFunction;
import java.util.function.BinaryOperator;

public class Java8BinaryOperator1 {

    public static void main(String[] args) {

        // BiFunction
        BiFunction<Integer, Integer, Integer> func = (x1, x2) -> x1 + x2;

        Integer result = func.apply(2, 3);

        System.out.println(result); // 5

        // BinaryOperator
        BinaryOperator<Integer> func2 = (x1, x2) -> x1 + x2;

        Integer result2 = func.apply(2, 3);

        System.out.println(result2); // 5

    }

}
```

**输出：**
```
5
5
```
## 实例2：把BinaryOperator作为参数传递

下面这个例子模拟使用`stream.reduce()`计算数组元素之和：

**Java8BinaryOperator2.java**

```java
package cc.myexample;

import java.util.Arrays;
import java.util.List;
import java.util.function.BinaryOperator;

public class Java8BinaryOperator2 {

    public static void main(String[] args) {

        Integer[] numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

        Integer result = math(Arrays.asList(numbers), 0, (a, b) -> a + b);

        System.out.println(result); // 55

        Integer result2 = math(Arrays.asList(numbers), 0, Integer::sum);

        System.out.println(result2); // 55

    }

    public static <T> T math(List<T> list, T init, BinaryOperator<T> accumulator) {
        T result = init;
        for (T t : list) {
            result = accumulator.apply(result, t);
        }
        return result;
    }

}
```

**输出：**

```
55
55
```

## 实例3：使用IntBinaryOperator提升性能

如果参与计算的两个参数类型是原生类型`int`，则可以使用IntBinaryOperator提供性能。

**Java8BinaryOperator3.java**
```java
package com.mkyong;

import java.util.function.IntBinaryOperator;
import java.util.stream.IntStream;

public class Java8BinaryOperator3 {

    public static void main(String[] args) {

        int[] numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

        int result = math((numbers), 0, (a, b) -> a + b);

        System.out.println(result); // 55

        int result2 = math((numbers), 0, Integer::sum);

        System.out.println(result2); // 55

        IntStream
    }

    public static int math(int[] list, int init, IntBinaryOperator accumulator) {
        int result = init;
        for (int t : list) {
            result = accumulator.applyAsInt(result, t);
        }
        return result;
    }

}
```

**输出：**

```
55
55
```

## 实例4：使用BinaryOperator计算最大/最小值。

BinaryOperator的`maxBy()`方法可以返回两个参数中较大的值，它的实现相当于三目表达式：a > b ? a : b。

BinaryOperator的`minBy()`方法可以返回两个参数中较小的值，它的实现相当于三目表达式：a < b ? a : b。

如果将`maxBy()`和`minBy()`用于对象的比较还需要实现一个自定义的`Comparator`接口。

**Java8BinaryOperator4.java**
```java
package cc.myexample;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.function.BinaryOperator;

public class Java8BinaryOperator4 {

    public static void main(String[] args) {

        Developer dev1 = new Developer("jordan", BigDecimal.valueOf(9999));
        Developer dev2 = new Developer("jack", BigDecimal.valueOf(8888));
        Developer dev3 = new Developer("jaden", BigDecimal.valueOf(10000));
        Developer dev4 = new Developer("ali", BigDecimal.valueOf(2000));
        Developer dev5 = new Developer("myexample", BigDecimal.valueOf(1));

        List<Developer> list = Arrays.asList(dev1, dev2, dev3, dev4, dev5);

        // 1. 创建一个Comparator，使用码农的工资作为排序
        Comparator<Developer> comparing = Comparator.comparing(Developer::getSalary);

        // 2. 使用maxBy方法创建一个BinaryOperator用于返回两参数中较大的值
        BinaryOperator<Developer> bo = BinaryOperator.maxBy(comparing);

        Developer result = find(list, bo);

        System.out.println(result);     // Developer{name='jaden', salary=10000}

        // 合并在一起

        // 寻找工资最高的程序员
        Developer developer = find(list, BinaryOperator.maxBy(Comparator.comparing(Developer::getSalary)));
        System.out.println(developer);  // Developer{name='jaden', salary=10000}

        // 寻找工资最低的程序员
        Developer developer2 = find(list, BinaryOperator.minBy(Comparator.comparing(Developer::getSalary)));
        System.out.println(developer2); // Developer{name='myexample', salary=1}

    }

    public static Developer find(List<Developer> list, BinaryOperator<Developer> accumulator) {
        Developer result = null;
        for (Developer t : list) {
            if (result == null) {
                result = t;
            } else {
                result = accumulator.apply(result, t);
            }
        }
        return result;
    }

}
```

**Developer.java**
```java
package cc.myexample;

import java.math.BigDecimal;

public class Developer {

    String name;
    BigDecimal salary;

    public Developer(String name, BigDecimal salary) {
        this.name = name;
        this.salary = salary;
    }

    // 省略toString方法的实现
}
```
**输出：**
```
Developer{name='jaden', salary=10000}
Developer{name='jaden', salary=10000}
Developer{name='myexample', salary=1}
```
