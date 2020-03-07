# Java 8 Predicate的使用方法及实例

在Java8中[Predicate](https://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html)是一个函数式接口，它可以接受一个类型为T的参数并返回一个布尔值，通常它被用于过滤出集合中满足条件的对象。

**Predicate.java**
```java
@FunctionalInterface
public interface Predicate<T> {
  boolean test(T t);
}
```

## 实例1：在Stream中使用
`Stream`的`filter()`方法可以接受一个`Predicate`作为参数。

下面的代码可以过滤出列表中大于5的数字：

**Java8Predicate.java**
```java
package cc.myexample.java8;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class Java8Predicate {

    public static void main(String[] args) {

        List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

        // 过滤出list中x大于5的元素
        List<Integer> collect = list.stream().filter(x -> x > 5).collect(Collectors.toList());

        System.out.println(collect); // [6, 7, 8, 9, 10]

    }

}
```
**输出**
```
[6, 7, 8, 9, 10]
```

## 实例2：使用Predicate.and()组合两个Predicate
`Predicate.and()`方法可以对两个独立的`Predicate`使用逻辑与关系进行组合。

先来看一下不使用`Predicate.and()`的情况。

下面的代码可以过滤出列表中大于5但是小于8的数字：

**Java8Predicate2.java**
```java
package cc.myexample.java8;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class Java8Predicate2 {

    public static void main(String[] args) {

        List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

        // 过滤出list中大于5且小于8的数字
        List<Integer> collect = list.stream()
                .filter(x -> x > 5 && x < 8).collect(Collectors.toList());

        System.out.println(collect);

    }

}
```

**输出**
```
[6, 7]
```

再来看一下如何使用`Predicate.and()`方法。

下面的代码过滤出列表中大于5但是小于8的数字：

**Java8Predicate2.java**
```java
package cc.myexample.java8;

import java.util.Arrays;
import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public class Java8Predicate2 {

    public static void main(String[] args) {

        // 过滤大于5的数字
        Predicate<Integer> noGreaterThan5 = x -> x > 5;
        // 过滤小于8的数字
        Predicate<Integer> noLessThan8 = x -> x < 8;

        List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);


        List<Integer> collect = list.stream()
                .filter(noGreaterThan5.and(noLessThan8)) // 组合两个独立的Predicate
                .collect(Collectors.toList());

        System.out.println(collect);

    }

}
```

**输出**
```
[6, 7]
```

## 实例3：使用Predicate.or()组合两个Predicate
`Predicate.and()`方法对两个独立的`Predicate`使用逻辑或关系进行组合。

下面的代码可以找出列表中长度等于3或者以“A”开头的字符串：

**Java8Predicate3.java**

```java
package com.mkyong.java8;

import java.util.Arrays;
import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public class Java8Predicate3 {

    public static void main(String[] args) {

        // 字符串长度等于3的情况
        Predicate<String> lengthIs3 = x -> x.length() == 3;
        // 字符串以A开头的情况
        Predicate<String> startWithA = x -> x.startsWith("A");

        List<String> list = Arrays.asList("A", "AA", "AAA", "B", "BB", "BBB");

        List<String> collect = list.stream()
                .filter(lengthIs3.or(startWithA)) // 组合两个独立的Predicate
                .collect(Collectors.toList());

        System.out.println(collect);

    }

}
```
**输出**
```
[A, AA, AAA, BBB]
```

## 实例4：使用Predicate.negate()对Predicate取反

`Predicate.negate()`方法可以对一个`Predicate`实现逻辑取反的效果。

下面的代码可以找出列表中不是以“A”开头的字符串。

**Java8Predicate4.java**

```java
package cc.myexample.java8;

import java.util.Arrays;
import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public class Java8Predicate4 {

    public static void main(String[] args) {

        Predicate<String> startWithA = x -> x.startsWith("A");

        List<String> list = Arrays.asList("A", "AA", "AAA", "B", "BB", "BBB");

        List<String> collect = list.stream()
                .filter(startWithA.negate())
                .collect(Collectors.toList());

        System.out.println(collect);

    }

}
```

**输出**
```
[B, BB, BBB]
```

## 实例5：使用Predicate.test()

**Java8Predicate5.java**
```java
package cc.myexample.java8;

import java.util.Arrays;
import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public class Java8Predicate5 {

    public static void main(String[] args) {

        List<String> list = Arrays.asList("A", "AA", "AAA", "B", "BB", "BBB");

        System.out.println(StringProcessor.filter(
                list, x -> x.startsWith("A")));                    // [A, AA, AAA]

        System.out.println(StringProcessor.filter(
                list, x -> x.startsWith("A") && x.length() == 3)); // [AAA]

    }

}

class StringProcessor {
    static List<String> filter(List<String> list, Predicate<String> predicate) {
        // 下面这两条语句是等价的
        // return list.stream().filter(predicate).collect(Collectors.toList());
        return list.stream().filter(predicate::test).collect(Collectors.toList());
    }
}
```

**输出**
```
[A, AA, AAA]
[AAA]
```

## 实例6：串联Predicate

**Java8Predicate6.java**

```java
package cc.myexample.java8;

import java.util.function.Predicate;

public class Java8Predicate6 {

    public static void main(String[] args) {

        Predicate<String> startWithA = x -> x.startsWith("a");

        // 以a或m开始的字符串
        boolean result = startWithA.or(x -> x.startsWith("m")).test("mkyong");
        System.out.println(result);     // true

        // 字符串不以a开始且长度不等于3
        boolean result2 = startWithA.and(x -> x.length() == 3).negate().test("abc");
        System.out.println(result2);    // false

    }

}
```

**输出**
```
true
false
```

