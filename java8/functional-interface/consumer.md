# Java 8 Consumer的使用方法及实例
在Java8中，[Consumer](https://docs.oracle.com/javase/8/docs/api/java/util/function/Consumer.html)是一个函数式接口，它接受一个参数。

**Consumer.java**
```java
@FunctionalInterface
public interface Consumer<T> {
  void accept(T t);
}
```

## 实例1：基本用法

下面的程序用于打印x到屏幕上：

**Java8Consumer1.java**

```java
package cc.myexample.java8;

import java.util.function.Consumer;

public class Java8Consumer1 {

    public static void main(String[] args) {

        Consumer<String> print = x -> System.out.println(x);
        print.accept("java");   // java

    }

}
```

**输出**
```
java
```

## 实例2：模拟forEach

**Java8Consumer2.java**
```java
package cc.myexample.java8;

import java.util.Arrays;
import java.util.List;
import java.util.function.Consumer;

public class Java8Consumer2 {

    public static void main(String[] args) {

        List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);

        // 通过变量的方式传递
        Consumer<Integer> consumer = (Integer x) -> System.out.println(x);
        forEach(list, consumer);

        // 或通过lambda的方式传递
        forEach(list, (Integer x) -> System.out.println(x));

    }

    static <T> void forEach(List<T> list, Consumer<T> consumer) {
        for (T t : list) {
            consumer.accept(t);
        }
    }

}
```
**输出**
```
1
2
3
4
5
1
2
3
4
5
```

我们对上面的程序进行一些改动，让它打印字符串的长度：

**Java8Consumer3.java**

```java
package cc.myexample.java8;

import java.util.Arrays;
import java.util.List;
import java.util.function.Consumer;

public class Java8Consumer3 {

    public static void main(String[] args) {

        List<String> list = Arrays.asList("a", "ab", "abc");
        forEach(list, (String x) -> System.out.println(x.length()));

    }

    static <T> void forEach(List<T> list, Consumer<T> consumer) {
        for (T t : list) {
            consumer.accept(t);
        }
    }

}
```
**输出**
```java
1
2
3
```
