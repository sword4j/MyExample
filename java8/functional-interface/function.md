# Java 8 Function的使用方法及实例

在Java 8中，[Function](https://docs.oracle.com/javase/8/docs/api/java/util/function/Function.html)是一个函数式接口，它可以接受一个参数（类型是T）并返回一个结果（类型是R），简单的说就是它可以接受一个参数然后返回一个结果。

**Function.java**

```java
@FunctionalInterface
public interface Function<T, R> {
	R apply(T t);
}
```

+ T - 输入参数的类型。
+ R - 返回结果的类型。

## 实例1：接受一个字符串作为参数以它的长度作为结果

**MyExample1.java**

```java
package cc.myexample;
import java.util.function.Function;

public class MyExample1 {
    public static void main(String[] args) {
        Function<String, Integer> func = x -> x.length();
        Integer apply = func.apply("myexample");   // 9
        System.out.println(apply);
    }
}
```

**输出:**

```
9
```

## 实例2：使用`andThen()`串联`Function`

**MyExample2.java**

```java
package cc.myexample;
import java.util.function.Function;

public class MyExample2 {
    public static void main(String[] args) {
        Function<String, Integer> func = x -> x.length();
        Function<Integer, Integer> func2 = x -> x * 2;
        Integer result = func.andThen(func2).apply("myexample");   // 18
        System.out.println(result);
    }
}
```

> PS：func2会使用func返回的结果作为输入，展开后看起来像这样func2.apply(func.apply("myexample"))

**输出:**

```
18
```

## 实例3：把List转为Map

该实例演示了基于`List<String>`创建一个Map用于保存字符串与字符串长度的映射。

```java
package cc.myexample;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

public class MyExample3 {
    public static void main(String[] args) {
        Java8Function3 obj = new Java8Function3();
        List<String> list = Arrays.asList("node", "c++", "java", "javascript");
        // 通过lambda表达式取字符串长度
        Map<String, Integer> map = obj.convertListToMap(list, x -> x.length());
        System.out.println(map);    // {node=4, c++=3, java=4, javascript=10}
        // 通过方法推导取字符串长度
        Map<String, Integer> map2 = obj.convertListToMap(list, obj::getLength);
        System.out.println(map2);
    }

    public <T, R> Map<T, R> convertListToMap(List<T> list, Function<T, R> func) {
        Map<T, R> result = new HashMap<>();
        for (T t : list) {
            result.put(t, func.apply(t));
        }
        return result;
    }

    public Integer getLength(String str) {
        return str.length();
    }
}
```

**输出：**

```
{node=4, c++=3, java=4, javascript=10}
{node=4, c++=3, java=4, javascript=10}
```

## 实例4：把List转为List

该实例演示了把Function作为参数传递，通过Function计算String的SHA256消息摘要。

**MyExample4.java**

```java
package com.mkyong;

import org.apache.commons.codec.digest.DigestUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.function.Function;

public class Java8Function4 {

    public static void main(String[] args) {

        Java8Function4 obj = new Java8Function4();

        List<String> list = Arrays.asList("node", "c++", "java", "javascript");

        // 方法推导
        List<String> result = obj.map(list, obj::sha256);

      	// 打印result中的每一个元素
        result.forEach(System.out::println);

    }

  	// 对list中的每一个元素应用func，最后返回一个新的List
    public <T, R> List<R> map(List<T> list, Function<T, R> func) {

        List<R> result = new ArrayList<>();
        for (T t : list) {
            result.add(func.apply(t));
        }
        return result;

    }

    // 计算SHA256消息摘要
    public String sha256(String str) {
        return DigestUtils.sha256Hex(str);
    }

}
```

**输出：**

```
545ea538461003efdc8c81c244531b003f6f26cfccf6c0073b3239fdedf49446
cedb1bac7efcd7db47e9f2f2250a7c832aba83b410dd85766e2aea6ec9321e51
38a0963a6364b09ad867aa9a66c6d009673c21e182015461da236ec361877f77
eda71746c01c3f465ffd02b6da15a6518e6fbc8f06f1ac525be193be5507069d
```

PS：计算SHA256需要依赖`commons-codec`包，下面给出它的Maven依赖。

**pom.xml**

```xml
<dependency>
  <groupId>commons-codec</groupId>
  <artifactId>commons-codec</artifactId>
  <version>1.14</version>
</dependency>
```


