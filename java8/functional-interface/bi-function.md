# Java 8 BiFunction的使用方法及实例

在Java8中，[BiFunction](https://docs.oracle.com/javase/8/docs/api/java/util/function/BiFunction.html)是一个函数式接口，它可以接受两个参数并返回一个结果。

**BiFunction.java**

```java
@FunctionalInterface
public interface BiFunction<T, U, R> {
      R apply(T t, U u);
}
```

- T – 第一个参数的类型。
- U – 第二个参数的类型。
- R – 返回结果的类型。

## 实例1：基本用法

使用两个参数做计算，然后返回一个结果。

**Java8BiFunction1.java**

```java
package cc.myexample;

import java.util.Arrays;
import java.util.List;
import java.util.function.BiFunction;

public class Java8BiFunction1 {

    public static void main(String[] args) {

        // 计算两数之和
        BiFunction<Integer, Integer, Integer> func = (x1, x2) -> x1 + x2;

        Integer result = func.apply(2, 3);

        System.out.println(result); // 5

        // 计算x1的x2次方
        BiFunction<Integer, Integer, Double> func2 = (x1, x2) -> Math.pow(x1, x2);

        Double result2 = func2.apply(2, 4);

        System.out.println(result2);    // 16.0

        // 将x1与x2的和通过List返回
        BiFunction<Integer, Integer, List<Integer>> func3 = (x1, x2) -> Arrays.asList(x1 + x2);
        List<Integer> result3 = func3.apply(2, 3);
        System.out.println(result3);
    }
}
```

**输出：**

```
5
16.0
[5]
```

## 实例2：BiFunction<T,U,R> 串联 Function<T,R>

**Java8BiFunction2a.java**

```java
package cc.myexample;

import java.util.function.BiFunction;
import java.util.function.Function;

public class Java8BiFunction2a {

    public static void main(String[] args) {

        // BiFunction，计算a1的a2次方，结果是Double类型
        BiFunction<Integer, Integer, Double> func1 = (a1, a2) -> Math.pow(a1, a2);

        // Function，把Double转为String
        Function<Double, String> func2 = (input) -> "Result : " + String.valueOf(input);

      	// 使用andThen串联BiFunction与Function
        String result = func1.andThen(func2).apply(2, 4);

        System.out.println(result);

    }

}
```

**输出：**

```
Result : 16.0
```

封装一下BiFunction与Function的组合逻辑使其变得更“通用”：

```java
public static <A1, A2, R1, R2> R2 convert(A1 a1, A2 a2,
                                          BiFunction<A1, A2, R1> func,
                                          Function<R1, R2> func2) {

    return func.andThen(func2).apply(a1, a2);

}
```

下面的代码演示了如何使用上面`convert`函数。

**Java8BiFunction2c.java**

```java
package cc.myexample;

import java.util.function.BiFunction;
import java.util.function.Function;

public class Java8BiFunction2c {

    public static void main(String[] args) {

        // 计算2的4次方，然后把结果转为String
        String result = convert(2, 4,
                (a1, a2) -> Math.pow(a1, a2),
                (r) -> "Pow : " + String.valueOf(r));

        System.out.println(result);     // Pow : 16.0

        // 计算2*4，然后把结果转为String
        String result2 = convert(2, 4,
                (a1, a2) -> a1 * a1,
                (r) -> "Multiply : " + String.valueOf(r));

        System.out.println(result2);    // Multiply : 4

        // 计算"a"+"b"，然后把结果转为String
        String result3 = convert("a", "b",
                (a1, a2) -> a1 + a2,
                (r) -> r + "cde");      // abcde

        System.out.println(result3);

        // 计算a1+a2，把结果转为Integer
        Integer result4 = convert("100", "200",
                (a1, a2) -> a1 + a2,
                (r) -> Integer.valueOf(r));

        System.out.println(result4);    // 100200

    }

    public static <A1, A2, R1, R2> R2 convert(A1 a1, A2 a2,
                                              BiFunction<A1, A2, R1> func,
                                              Function<R1, R2> func2) {

        return func.andThen(func2).apply(a1, a2);

    }

}
```

**输出：**

```
Pow : 16.0
Multiply : 4
abcde
100200
```

## 实例3：实现工厂模式

**Java8BiFunction3.java**

```java
package cc.myexample;

import java.util.function.BiFunction;

public class Java8BiFunction3 {

    public static void main(String[] args) {

        GPS obj = factory("40.741895", "-73.989308", GPS::new);
        System.out.println(obj);

    }

    public static <R extends GPS> R factory(String Latitude, String Longitude,
                                            BiFunction<String, String, R> func) {
        return func.apply(Latitude, Longitude);
    }

}

class GPS {

    String Latitude;
    String Longitude;

    public GPS(String latitude, String longitude) {
        Latitude = latitude;
        Longitude = longitude;
    }

    public String getLatitude() {
        return Latitude;
    }

    public void setLatitude(String latitude) {
        Latitude = latitude;
    }

    public String getLongitude() {
        return Longitude;
    }

    public void setLongitude(String longitude) {
        Longitude = longitude;
    }

    @Override
    public String toString() {
        return "GPS{" +
                "Latitude='" + Latitude + '\'' +
                ", Longitude='" + Longitude + '\'' +
                '}';
    }
}
```

**输出：**

```
GPS{Latitude='40.741895', Longitude='-73.989308'}
```

`GPS::new`调用的是GPS类的构造器，这个构造器与BiFunction具有同样的签名(具有两个类型为String的参数).

```java
public GPS(String latitude, String longitude) {
  Latitude = latitude;
  Longitude = longitude;
}
```

## 实例4：条件过滤

**Java8BiFunction4.java**

```java
package cc.myexample;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.function.BiFunction;

public class Java8BiFunction4 {

    public static void main(String[] args) {

        Java8BiFunction4 obj = new Java8BiFunction4();

        // 过滤出List中长度大于3的字符串（方法推导）
        List<String> list = Arrays.asList("node", "c++", "java", "javascript");

        List<String> result = obj.filterList(list, 3, obj::filterByLength);

        System.out.println(result);   // [node, java, javascript]

      	// 过滤出List中长度大于3的字符串（lambda表达式）
        List<String> result1 = obj.filterList(list, 3, (l1, size) -> {
            if (l1.length() > size) {
                return l1;
            } else {
                return null;
            }
        });

        System.out.println(result1);  // [node, java, javascript]

      	// 过滤出List中以"c"开头的字符串
        List<String> result2 = obj.filterList(list, "c", (l1, condition) -> {
            if (l1.startsWith(condition)) {
                return l1;
            } else {
                return null;
            }
        });

        System.out.println(result2);  // [c++]

        List<Integer> number = Arrays.asList(1, 2, 3, 4, 5);
				
      	// 过滤出List中可以被2整除的数
        List<Integer> result3 = obj.filterList(number, 2, (l1, condition) -> {
            if (l1 % condition == 0) {
                return l1;
            } else {
                return null;
            }
        });

        System.out.println(result3);  // [2, 4]

    }

    public String filterByLength(String str, Integer size) {
        if (str.length() > size) {
            return str;
        } else {
            return null;
        }
    }

    public <T, U, R> List<R> filterList(List<T> list1, U condition,
                                        BiFunction<T, U, R> func) {

        List<R> result = new ArrayList<>();

        for (T t : list1) {
            R apply = func.apply(t, condition);
            if (apply != null) {
                result.add(apply);
            }
        }

        return result;

    }

}
```

**输出：**

```
[node, java, javascript]
[node, java, javascript]
[c++]
[2, 4]
```

