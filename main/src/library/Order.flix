/*
 * Copyright 2020 Esben Bjerre
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

///
/// A type class for types with a total order.
///
pub class Order[a] {

    /// Returns `true` if and only if `x < y`.
    pub def less(x: a, y: a): Bool

    /// Returns `true` if and only if `x <= y`.
    pub def lessEqual(x: a, y: a): Bool

    /// Returns `true` if and only if `x > y`.
    pub def greater(x: a, y: a): Bool

    /// Returns `true` if and only if `x >= y`.
    pub def greaterEqual(x: a, y: a): Bool

    ///
    /// Returns `LessThan` if `x` < `y`, `Equal` if `x` == `y` or `GreaterThan` `if `x` > `y`.
    ///
    pub def compare(x: a, y: a): Comparison

}

namespace Order {

    ///
    /// Converts a `Comparison` value to an integer.
    /// The return value is:
    /// `-1` if `c` is `LessThan`.
    /// `0` if `c` is `EqualTo`.
    /// `+1` if `c` is `GreaterThan`.
    ///
    pub def toInt(c: Comparison): Int32 = match c {
        case LessThan => -1
        case EqualTo => 0
        case GreaterThan => +1
    }

    ///
    /// Converts an integer to a `Comparison` value.
    /// The return value is:
    /// `LessThan` if `i < 0`.
    /// `EqualTo` if `i == 0`.
    /// `GreaterThan` if `i > 0`.
    ///
    pub def fromInt(i: Int32): Comparison =
        if (i < 0) LessThan
        else if (i == 0) EqualTo
        else GreaterThan

    ///
    /// Returns the minimum of `x` and `y`.
    ///
    pub def min[a : Order](x: a, y: a): a = match (x <=> y) {
        case GreaterThan => y
        case _ => x
    }

    ///
    /// Returns the minimum of `x` and `y` according to the given comparator `cmp`.
    ///
    pub def minBy(cmp: (a, a) -> Comparison, x: a, y: a): a =
        if (cmp(x, y) == GreaterThan) y else x

    ///
    /// Returns the maximum of `x` and `y`.
    ///
    pub def max[a : Order](x: a, y: a): a = match (x <=> y) {
        case LessThan => y
        case _ => x
    }

    ///
    /// Returns the maximum of `x` and `y` according to the given comparator `cmp`.
    ///
    pub def maxBy(cmp: (a, a) -> Comparison, x: a, y: a): a =
        if (cmp(x, y) == LessThan) y else x

    ///
    /// Lazily combines two comparisons.
    ///
    /// If `c1` is either `LessThan` or `GreaterThan` then `c2` is never evaluated.
    ///
    pub def thenCompare(c1: Comparison, c2: Lazy[Comparison]): Comparison =
        if (c1 != EqualTo) c1 else force c2

}

instance Order[Unit] {

    def less(x: Unit, y: Unit): Bool = false
    def lessEqual(x: Unit, y: Unit): Bool = true
    def greater(x: Unit, y: Unit): Bool = false
    def greaterEqual(x: Unit, y: Unit): Bool = true
    pub def compare(x: Unit, y: Unit): Comparison = EqualTo

}

instance Order[Bool] {

    def less(x: Bool, y: Bool): Bool = match (x <=> y) {
        case LessThan => true
        case _ => false
    }
    def lessEqual(x: Bool, y: Bool): Bool = match (x <=> y) {
        case LessThan => true
        case EqualTo => true
        case _ => false
    }
    def greater(x: Bool, y: Bool): Bool = match (x <=> y) {
        case GreaterThan => true
        case _ => false
    }
    def greaterEqual(x: Bool, y: Bool): Bool = match (x <=> y) {
        case GreaterThan => true
        case EqualTo => true
        case _ => false
    }
    def compare(x: Bool, y: Bool): Comparison = match (x, y) {
        case (true, true) => EqualTo
        case (false, false) => EqualTo
        case (false, true) => LessThan
        case (true, false) => GreaterThan
    }

}

instance Order[Char] {

    def less(x: Char, y: Char): Bool = $CHAR_LT$(x, y)
    def lessEqual(x: Char, y: Char): Bool = $CHAR_LE$(x, y)
    def greater(x: Char, y: Char): Bool = $CHAR_GT$(x, y)
    def greaterEqual(x: Char, y: Char): Bool = $CHAR_GE$(x, y)
    def compare(x: Char, y: Char): Comparison = match (x <= y, y <= x) {
        case (true, true) => EqualTo
        case (true, false) => LessThan
        case (false, true) => GreaterThan
    }

}

instance Order[Float32] {

    def less(x: Float32, y: Float32): Bool = $FLOAT32_LT$(x, y)
    def lessEqual(x: Float32, y: Float32): Bool = $FLOAT32_LE$(x, y)
    def greater(x: Float32, y: Float32): Bool = $FLOAT32_GT$(x, y)
    def greaterEqual(x: Float32, y: Float32): Bool = $FLOAT32_GE$(x, y)
    def compare(x: Float32, y: Float32): Comparison = match (x <= y, y <= x) {
        case (true, true) => EqualTo
        case (true, false) => LessThan
        case (false, true) => GreaterThan
    }

}

instance Order[Float64] {

    def less(x: Float64, y: Float64): Bool = $FLOAT64_LT$(x, y)
    def lessEqual(x: Float64, y: Float64): Bool = $FLOAT64_LE$(x, y)
    def greater(x: Float64, y: Float64): Bool = $FLOAT64_GT$(x, y)
    def greaterEqual(x: Float64, y: Float64): Bool = $FLOAT64_GE$(x, y)
    def compare(x: Float64, y: Float64): Comparison = match (x <= y, y <= x) {
        case (true, true) => EqualTo
        case (true, false) => LessThan
        case (false, true) => GreaterThan
    }

}

instance Order[Int8] {

    def less(x: Int8, y: Int8): Bool = $INT8_LT$(x, y)
    def lessEqual(x: Int8, y: Int8): Bool = $INT8_LE$(x, y)
    def greater(x: Int8, y: Int8): Bool = $INT8_GT$(x, y)
    def greaterEqual(x: Int8, y: Int8): Bool = $INT8_GE$(x, y)
    def compare(x: Int8, y: Int8): Comparison = match (x <= y, y <= x) {
        case (true, true) => EqualTo
        case (true, false) => LessThan
        case (false, true) => GreaterThan
    }

}

instance Order[Int16] {

    def less(x: Int16, y: Int16): Bool = $INT16_LT$(x, y)
    def lessEqual(x: Int16, y: Int16): Bool = $INT16_LE$(x, y)
    def greater(x: Int16, y: Int16): Bool = $INT16_GT$(x, y)
    def greaterEqual(x: Int16, y: Int16): Bool = $INT16_GE$(x, y)
    def compare(x: Int16, y: Int16): Comparison = match (x <= y, y <= x) {
        case (true, true) => EqualTo
        case (true, false) => LessThan
        case (false, true) => GreaterThan
    }

}

instance Order[Int32] {

    def less(x: Int32, y: Int32): Bool = $INT32_LT$(x, y)
    def lessEqual(x: Int32, y: Int32): Bool = $INT32_LE$(x, y)
    def greater(x: Int32, y: Int32): Bool = $INT32_GT$(x, y)
    def greaterEqual(x: Int32, y: Int32): Bool = $INT32_GE$(x, y)
    def compare(x: Int32, y: Int32): Comparison = match (x <= y, y <= x) {
        case (true, true) => EqualTo
        case (true, false) => LessThan
        case (false, true) => GreaterThan
    }

}

instance Order[Int64] {

    def less(x: Int64, y: Int64): Bool = $INT64_LT$(x, y)
    def lessEqual(x: Int64, y: Int64): Bool = $INT64_LE$(x, y)
    def greater(x: Int64, y: Int64): Bool = $INT64_GT$(x, y)
    def greaterEqual(x: Int64, y: Int64): Bool = $INT64_GE$(x, y)
    def compare(x: Int64, y: Int64): Comparison = match (x <= y, y <= x) {
        case (true, true) => EqualTo
        case (true, false) => LessThan
        case (false, true) => GreaterThan
    }

}

instance Order[BigInt] {

    def less(x: BigInt, y: BigInt): Bool = $BIGINT_LT$(x, y)
    def lessEqual(x: BigInt, y: BigInt): Bool = $BIGINT_LE$(x, y)
    def greater(x: BigInt, y: BigInt): Bool = $BIGINT_GT$(x, y)
    def greaterEqual(x: BigInt, y: BigInt): Bool = $BIGINT_GE$(x, y)
    def compare(x: BigInt, y: BigInt): Comparison = match (x <= y, y <= x) {
        case (true, true) => EqualTo
        case (true, false) => LessThan
        case (false, true) => GreaterThan
    }

}

instance Order[String] {

    def less(x: String, y: String): Bool = match (x <=> y) {
        case LessThan => true
        case _ => false
    }
    def lessEqual(x: String, y: String): Bool = match (x <=> y) {
        case LessThan => true
        case EqualTo => true
        case _ => false
    }
    def greater(x: String, y: String): Bool = match (x <=> y) {
        case GreaterThan => true
        case _ => false
    }
    def greaterEqual(x: String, y: String): Bool = match (x <=> y) {
        case GreaterThan => true
        case EqualTo => true
        case _ => false
    }

    def compare(x: String, y: String): Comparison =
        import java.lang.String.compareTo(String);
        Order.fromInt(x.compareTo(y) as & Pure)

}

instance Order[(a1, a2)] with [a1 : Order, a2: Order] {

    def less(x: (a1, a2), y: (a1, a2)): Bool = match (x <=> y) {
        case LessThan => true
        case _ => false
    }
    def lessEqual(x: (a1, a2), y: (a1, a2)): Bool = match (x <=> y) {
        case LessThan => true
        case EqualTo => true
        case _ => false
    }
    def greater(x: (a1, a2), y: (a1, a2)): Bool = match (x <=> y) {
        case GreaterThan => true
        case _ => false
    }
    def greaterEqual(x: (a1, a2), y: (a1, a2)): Bool = match (x <=> y) {
        case GreaterThan => true
        case EqualTo => true
        case _ => false
    }

    ///
    /// Compares `t1` and `t2` lexicographically.
    ///
    def compare(t1: (a1, a2), t2: (a1, a2)): Comparison =
        use Order.thenCompare;
        let (x1, x2) = t1;
        let (y1, y2) = t2;
             (x1 <=> y1) `thenCompare`
        lazy (x2 <=> y2)

}

instance Order[(a1, a2, a3)] with [a1 : Order, a2: Order, a3 : Order] {

    def less(x: (a1, a2, a3), y: (a1, a2, a3)): Bool = match (x <=> y) {
        case LessThan => true
        case _ => false
    }
    def lessEqual(x: (a1, a2, a3), y: (a1, a2, a3)): Bool = match (x <=> y) {
        case LessThan => true
        case EqualTo => true
        case _ => false
    }
    def greater(x: (a1, a2, a3), y: (a1, a2, a3)): Bool = match (x <=> y) {
        case GreaterThan => true
        case _ => false
    }
    def greaterEqual(x: (a1, a2, a3), y: (a1, a2, a3)): Bool = match (x <=> y) {
        case GreaterThan => true
        case EqualTo => true
        case _ => false
    }

    ///
    /// Compares `t1` and `t2` lexicographically.
    ///
    def compare(t1: (a1, a2, a3), t2: (a1, a2, a3)): Comparison =
        use Order.thenCompare;
        let (x1, x2, x3) = t1;
        let (y1, y2, y3) = t2;
             (x1 <=> y1) `thenCompare`
        lazy (x2 <=> y2) `thenCompare`
        lazy (x3 <=> y3)

}

instance Order[(a1, a2, a3, a4)] with [a1 : Order, a2: Order, a3 : Order, a4 : Order] {

    def less(x: (a1, a2, a3, a4), y: (a1, a2, a3, a4)): Bool = match (x <=> y) {
        case LessThan => true
        case _ => false
    }
    def lessEqual(x: (a1, a2, a3, a4), y: (a1, a2, a3, a4)): Bool = match (x <=> y) {
        case LessThan => true
        case EqualTo => true
        case _ => false
    }
    def greater(x: (a1, a2, a3, a4), y: (a1, a2, a3, a4)): Bool = match (x <=> y) {
        case GreaterThan => true
        case _ => false
    }
    def greaterEqual(x: (a1, a2, a3, a4), y: (a1, a2, a3, a4)): Bool = match (x <=> y) {
        case GreaterThan => true
        case EqualTo => true
        case _ => false
    }

    ///
    /// Compares `t1` and `t2` lexicographically.
    ///
    def compare(t1: (a1, a2, a3, a4), t2: (a1, a2, a3, a4)): Comparison =
        use Order.thenCompare;
        let (x1, x2, x3, x4) = t1;
        let (y1, y2, y3, y4) = t2;
             (x1 <=> y1) `thenCompare`
        lazy (x2 <=> y2) `thenCompare`
        lazy (x3 <=> y3) `thenCompare`
        lazy (x4 <=> y4)

}

instance Order[(a1, a2, a3, a4, a5)] with [a1 : Order, a2: Order, a3 : Order, a4 : Order, a5 : Order] {

    def less(x: (a1, a2, a3, a4, a5), y: (a1, a2, a3, a4, a5)): Bool = match (x <=> y) {
        case LessThan => true
        case _ => false
    }
    def lessEqual(x: (a1, a2, a3, a4, a5), y: (a1, a2, a3, a4, a5)): Bool = match (x <=> y) {
        case LessThan => true
        case EqualTo => true
        case _ => false
    }
    def greater(x: (a1, a2, a3, a4, a5), y: (a1, a2, a3, a4, a5)): Bool = match (x <=> y) {
        case GreaterThan => true
        case _ => false
    }
    def greaterEqual(x: (a1, a2, a3, a4, a5), y: (a1, a2, a3, a4, a5)): Bool = match (x <=> y) {
        case GreaterThan => true
        case EqualTo => true
        case _ => false
    }

    ///
    /// Compares `t1` and `t2` lexicographically.
    ///
    def compare(t1: (a1, a2, a3, a4, a5), t2: (a1, a2, a3, a4, a5)): Comparison =
        use Order.thenCompare;
        let (x1, x2, x3, x4, x5) = t1;
        let (y1, y2, y3, y4, y5) = t2;
             (x1 <=> y1) `thenCompare`
        lazy (x2 <=> y2) `thenCompare`
        lazy (x3 <=> y3) `thenCompare`
        lazy (x4 <=> y4) `thenCompare`
        lazy (x5 <=> y5)

}

instance Order[(a1, a2, a3, a4, a5, a6)] with [a1 : Order, a2: Order, a3 : Order, a4 : Order, a5 : Order, a6 : Order] {

    def less(x: (a1, a2, a3, a4, a5, a6), y: (a1, a2, a3, a4, a5, a6)): Bool = match (x <=> y) {
        case LessThan => true
        case _ => false
    }
    def lessEqual(x: (a1, a2, a3, a4, a5, a6), y: (a1, a2, a3, a4, a5, a6)): Bool = match (x <=> y) {
        case LessThan => true
        case EqualTo => true
        case _ => false
    }
    def greater(x: (a1, a2, a3, a4, a5, a6), y: (a1, a2, a3, a4, a5, a6)): Bool = match (x <=> y) {
        case GreaterThan => true
        case _ => false
    }
    def greaterEqual(x: (a1, a2, a3, a4, a5, a6), y: (a1, a2, a3, a4, a5, a6)): Bool = match (x <=> y) {
        case GreaterThan => true
        case EqualTo => true
        case _ => false
    }

    ///
    /// Compares `t1` and `t2` lexicographically.
    ///
    def compare(t1: (a1, a2, a3, a4, a5, a6), t2: (a1, a2, a3, a4, a5, a6)): Comparison =
        use Order.thenCompare;
        let (x1, x2, x3, x4, x5, x6) = t1;
        let (y1, y2, y3, y4, y5, y6) = t2;
             (x1 <=> y1) `thenCompare`
        lazy (x2 <=> y2) `thenCompare`
        lazy (x3 <=> y3) `thenCompare`
        lazy (x4 <=> y4) `thenCompare`
        lazy (x5 <=> y5) `thenCompare`
        lazy (x6 <=> y6)

}

instance Order[(a1, a2, a3, a4, a5, a6, a7)] with [a1 : Order, a2: Order, a3 : Order, a4 : Order, a5 : Order, a6 : Order, a7 : Order] {

    def less(x: (a1, a2, a3, a4, a5, a6, a7), y: (a1, a2, a3, a4, a5, a6, a7)): Bool = match (x <=> y) {
        case LessThan => true
        case _ => false
    }
    def lessEqual(x: (a1, a2, a3, a4, a5, a6, a7), y: (a1, a2, a3, a4, a5, a6, a7)): Bool = match (x <=> y) {
        case LessThan => true
        case EqualTo => true
        case _ => false
    }
    def greater(x: (a1, a2, a3, a4, a5, a6, a7), y: (a1, a2, a3, a4, a5, a6, a7)): Bool = match (x <=> y) {
        case GreaterThan => true
        case _ => false
    }
    def greaterEqual(x: (a1, a2, a3, a4, a5, a6, a7), y: (a1, a2, a3, a4, a5, a6, a7)): Bool = match (x <=> y) {
        case GreaterThan => true
        case EqualTo => true
        case _ => false
    }

    ///
    /// Compares `t1` and `t2` lexicographically.
    ///
    def compare(t1: (a1, a2, a3, a4, a5, a6, a7), t2: (a1, a2, a3, a4, a5, a6, a7)): Comparison =
        use Order.thenCompare;
        let (x1, x2, x3, x4, x5, x6, x7) = t1;
        let (y1, y2, y3, y4, y5, y6, y7) = t2;
             (x1 <=> y1) `thenCompare`
        lazy (x2 <=> y2) `thenCompare`
        lazy (x3 <=> y3) `thenCompare`
        lazy (x4 <=> y4) `thenCompare`
        lazy (x5 <=> y5) `thenCompare`
        lazy (x6 <=> y6) `thenCompare`
        lazy (x7 <=> y7)

}

instance Order[(a1, a2, a3, a4, a5, a6, a7, a8)] with [a1 : Order, a2: Order, a3 : Order, a4 : Order, a5 : Order, a6 : Order, a7 : Order, a8 : Order] {

    def less(x: (a1, a2, a3, a4, a5, a6, a7, a8), y: (a1, a2, a3, a4, a5, a6, a7, a8)): Bool = match (x <=> y) {
        case LessThan => true
        case _ => false
    }
    def lessEqual(x: (a1, a2, a3, a4, a5, a6, a7, a8), y: (a1, a2, a3, a4, a5, a6, a7, a8)): Bool = match (x <=> y) {
        case LessThan => true
        case EqualTo => true
        case _ => false
    }
    def greater(x: (a1, a2, a3, a4, a5, a6, a7, a8), y: (a1, a2, a3, a4, a5, a6, a7, a8)): Bool = match (x <=> y) {
        case GreaterThan => true
        case _ => false
    }
    def greaterEqual(x: (a1, a2, a3, a4, a5, a6, a7, a8), y: (a1, a2, a3, a4, a5, a6, a7, a8)): Bool = match (x <=> y) {
        case GreaterThan => true
        case EqualTo => true
        case _ => false
    }

    ///
    /// Compares `t1` and `t2` lexicographically.
    ///
    def compare(t1: (a1, a2, a3, a4, a5, a6, a7, a8), t2: (a1, a2, a3, a4, a5, a6, a7, a8)): Comparison =
        use Order.thenCompare;
        let (x1, x2, x3, x4, x5, x6, x7, x8) = t1;
        let (y1, y2, y3, y4, y5, y6, y7, y8) = t2;
             (x1 <=> y1) `thenCompare`
        lazy (x2 <=> y2) `thenCompare`
        lazy (x3 <=> y3) `thenCompare`
        lazy (x4 <=> y4) `thenCompare`
        lazy (x5 <=> y5) `thenCompare`
        lazy (x6 <=> y6) `thenCompare`
        lazy (x7 <=> y7) `thenCompare`
        lazy (x8 <=> y8)

}

instance Order[(a1, a2, a3, a4, a5, a6, a7, a8, a9)] with [a1 : Order, a2: Order, a3 : Order, a4 : Order, a5 : Order, a6 : Order, a7 : Order, a8 : Order, a9: Order] {

    def less(x: (a1, a2, a3, a4, a5, a6, a7, a8, a9), y: (a1, a2, a3, a4, a5, a6, a7, a8, a9)): Bool = match (x <=> y) {
        case LessThan => true
        case _ => false
    }
    def lessEqual(x: (a1, a2, a3, a4, a5, a6, a7, a8, a9), y: (a1, a2, a3, a4, a5, a6, a7, a8, a9)): Bool = match (x <=> y) {
        case LessThan => true
        case EqualTo => true
        case _ => false
    }
    def greater(x: (a1, a2, a3, a4, a5, a6, a7, a8, a9), y: (a1, a2, a3, a4, a5, a6, a7, a8, a9)): Bool = match (x <=> y) {
        case GreaterThan => true
        case _ => false
    }
    def greaterEqual(x: (a1, a2, a3, a4, a5, a6, a7, a8, a9), y: (a1, a2, a3, a4, a5, a6, a7, a8, a9)): Bool = match (x <=> y) {
        case GreaterThan => true
        case EqualTo => true
        case _ => false
    }

    ///
    /// Compares `t1` and `t2` lexicographically.
    ///
    def compare(t1: (a1, a2, a3, a4, a5, a6, a7, a8, a9), t2: (a1, a2, a3, a4, a5, a6, a7, a8, a9)): Comparison =
        use Order.thenCompare;
        let (x1, x2, x3, x4, x5, x6, x7, x8, x9) = t1;
        let (y1, y2, y3, y4, y5, y6, y7, y8, y9) = t2;
             (x1 <=> y1) `thenCompare`
        lazy (x2 <=> y2) `thenCompare`
        lazy (x3 <=> y3) `thenCompare`
        lazy (x4 <=> y4) `thenCompare`
        lazy (x5 <=> y5) `thenCompare`
        lazy (x6 <=> y6) `thenCompare`
        lazy (x7 <=> y7) `thenCompare`
        lazy (x8 <=> y8) `thenCompare`
        lazy (x9 <=> y9)

}

instance Order[(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)] with [a1 : Order, a2: Order, a3 : Order, a4 : Order, a5 : Order, a6 : Order, a7 : Order, a8 : Order, a9 : Order, a10 : Order] {

    def less(x: (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10), y: (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)): Bool = match (x <=> y) {
        case LessThan => true
        case _ => false
    }
    def lessEqual(x: (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10), y: (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)): Bool = match (x <=> y) {
        case LessThan => true
        case EqualTo => true
        case _ => false
    }
    def greater(x: (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10), y: (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)): Bool = match (x <=> y) {
        case GreaterThan => true
        case _ => false
    }
    def greaterEqual(x: (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10), y: (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)): Bool = match (x <=> y) {
        case GreaterThan => true
        case EqualTo => true
        case _ => false
    }

    ///
    /// Compares `t1` and `t2` lexicographically.
    ///
    def compare(t1: (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10), t2: (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)): Comparison =
        use Order.thenCompare;
        let (x1, x2, x3, x4, x5, x6, x7, x8, x9, x10) = t1;
        let (y1, y2, y3, y4, y5, y6, y7, y8, y9, y10) = t2;
             (x1 <=> y1) `thenCompare`
        lazy (x2 <=> y2) `thenCompare`
        lazy (x3 <=> y3) `thenCompare`
        lazy (x4 <=> y4) `thenCompare`
        lazy (x5 <=> y5) `thenCompare`
        lazy (x6 <=> y6) `thenCompare`
        lazy (x7 <=> y7) `thenCompare`
        lazy (x8 <=> y8) `thenCompare`
        lazy (x9 <=> y9) `thenCompare`
        lazy (x10 <=> y10)

}