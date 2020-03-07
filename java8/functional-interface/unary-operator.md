# Java 8 Predicate的使用方法及实例

在Java8中，[UnaryOperator](https://docs.oracle.com/javase/8/docs/api/java/util/function/UnaryOperator.html)是一个函数式接口，它继承自[Function](function.md)。

顾名思义`UnaryOperator`是一个“一元操作符”，它只接受一个参数并返回一个与参数类型一样的结果。

**UnaryOperator.java**

```java
@FunctionalInterface
public interface UnaryOperator<T> extends Function<T, T> {
}
```

相比之下，`Function`则可以接受一个任意类型的参数并返回一个任意类型的结果。

**Function.java**

```java
@FunctionalInterface
public interface Function<T, R> {
    R apply(T t);
}
```

进一步阅读：[Java 8 Function的使用方法及实例](function.md)

## 实例1：使用UnaryOperator替换Function

当Function的参数类型与返回值的类型一致时可以使用UnaryOperator替换Function，比如：可以使用`UnaryOperator<Integer>`替换`Function<Integer, Integer>`。

下面的程序用于计算2 * x：

**Java8UnaryOperator1.java**

```
package cc.myexample;

import java.util.function.Function;
import java.util.function.UnaryOperator;

public class Java8UnaryOperator1 {

    public static void main(String[] args) {

        // 使用Function
        Function<Integer, Integer> func = x -> x * 2;

        Integer result = func.apply(2);

        System.out.println(result);         // 4

        // 使用UnaryOperator
        UnaryOperator<Integer> func2 = x -> x * 2;

        Integer result2 = func2.apply(2);

        System.out.println(result2);        // 4

    }

}
```
**输出**
```
4
4
```

## 实例2：UnaryOperator作为参数传递

下面的代码演示了把列表中的每个元素都乘上2：

**Java8UnaryOperator2.java**
```
package cc.myexample;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.function.UnaryOperator;

public class Java8UnaryOperator2 {

    public static void main(String[] args) {

        List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
        
        // 把list中的每个元素乘上2
        List<Integer> result = math(list, x -> x * 2);

        System.out.println(result); // [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]

    }

    public static <T> List<T> math(List<T> list, UnaryOperator<T> uo) {
        List<T> result = new ArrayList<>();
        for (T t : list) {
            result.add(uo.apply(t));
        }
        return result;
    }

}
```

**输出**

```
[2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
```

## 实例3：串联UnaryOperator
与[Function](function.md)一样，`UnaryOperator`也可以使用`andThen()`方法进行串联。

假设存在下面两个UnaryOperator：
+ UnaryOperator<Integer> uo = x -> x * 2;
+ UnaryOperator<Integer> u2 = x -> x + 1;

则`uo.andThen(uo2).apply(3)`相当于`u2.apply(uo.apply(3))`，即计算3 * 2 + 1。

**Java8UnaryOperator3.java**
```
package cc.myexample;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.function.UnaryOperator;

public class Java8UnaryOperator3 {

    public static void main(String[] args) {

        List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

        // 先计算x * 2再把结果加上1
        List<Integer> result = math(list,
                x -> x * 2,
                x -> x + 1);

        System.out.println(result); // [3, 5, 7, 9, 11, 13, 15, 17, 19, 21]

    }

    public static <T> List<T> math(List<T> list,
                                   UnaryOperator<T> uo, UnaryOperator<T> uo2) {
        List<T> result = new ArrayList<>();
        for (T t : list) {
            result.add(uo.andThen(uo2).apply(t));
        }
        return result;
    }

}
```

**输出**
```
[3, 5, 7, 9, 11, 13, 15, 17, 19, 21]
```