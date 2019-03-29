---
layout: default
title : Universes (Introduction to Univalent Foundations of Mathematics with Agda)
date : 2019-03-04
---
## <a name="lecturenotes">Introduction to Univalent Foundations of Mathematics with Agda</a>

[<sub>Table of contents ⇑</sub>](toc.html#contents)
## Universes

We define our notation for type universes used in these notes, which
is different from the [standard Agda notation](https://agda.readthedocs.io/en/latest/language/universe-levels.html), but closer to the
standard notation in HoTT/UF.

Readers unfamiliar with Agda should probably try to understand this
only after doing some [MLTT in Agda](MLTT-Agda) and [HoTT/UF in
Agda](HoTT-UF-Agda).

<pre class="Agda">
<a id="688" class="Symbol">{-#</a> <a id="692" class="Keyword">OPTIONS</a> <a id="700" class="Pragma">--without-K</a> <a id="712" class="Pragma">--exact-split</a> <a id="726" class="Pragma">--safe</a> <a id="733" class="Symbol">#-}</a>

<a id="738" class="Keyword">module</a> <a id="745" href="Universes.html" class="Module">Universes</a> <a id="755" class="Keyword">where</a>

<a id="762" class="Keyword">open</a> <a id="767" class="Keyword">import</a> <a id="774" href="Universes.html" class="Module">Agda.Primitive</a> <a id="789" class="Keyword">public</a>
 <a id="797" class="Keyword">renaming</a> <a id="806" class="Symbol">(</a>
            <a id="820" href="Universes.html#408" class="Postulate">Level</a> <a id="826" class="Symbol">to</a> <a id="829" href="Agda.Primitive.html#408" class="Postulate">Universe</a> <a id="838" class="Comment">-- We speak of universes rather than of levels.</a>
          <a id="896" class="Symbol">;</a> <a id="898" href="Universes.html#611" class="Primitive">lzero</a> <a id="904" class="Symbol">to</a> <a id="907" href="Agda.Primitive.html#611" class="Primitive">𝓤₀</a>       <a id="916" class="Comment">-- Our first universe is called 𝓤₀</a>
          <a id="961" class="Symbol">;</a> <a id="963" href="Universes.html#627" class="Primitive">lsuc</a> <a id="968" class="Symbol">to</a> <a id="971" href="Agda.Primitive.html#627" class="Primitive">_⁺</a>        <a id="981" class="Comment">-- The universe after 𝓤 is 𝓤 ⁺</a>
          <a id="1022" class="Symbol">;</a> <a id="1024" href="Universes.html#808" class="Primitive">Setω</a> <a id="1029" class="Symbol">to</a> <a id="1032" href="Agda.Primitive.html#808" class="Primitive">𝓤ω</a>        <a id="1042" class="Comment">-- There is a universe 𝓤ω strictly above 𝓤₀, 𝓤₁, ⋯ , 𝓤ₙ, ⋯</a>
          <a id="1111" class="Symbol">)</a>
 <a id="1114" class="Keyword">using</a>    <a id="1123" class="Symbol">(</a><a id="1124" href="Universes.html#657" class="Primitive Operator">_⊔_</a><a id="1127" class="Symbol">)</a>               <a id="1143" class="Comment">-- Least upper bound of two universes, e.g. 𝓤₀ ⊔ 𝓤₁ is 𝓤₁</a>
</pre>

The elements of `Universe` are universe names. Given a name `𝓤`, the
universe itself will be written `𝓤 ̇` &nbsp; in these notes, with a
deliberately almost invisible superscript dot.

We actually need to define this notation, because traditionally in
Agda if one uses `ℓ` for a universe level, then `Set ℓ` is the type of
types of level `ℓ`. However, this notation is not good for univalent
foundations, because not all types are sets. Also the terminology
"level" is not good, because the hlevels in univalent type theory
refer to the complexity of equality rather than size.

The following should be the only use of the Agda keyword `Set` in
these notes.

<pre class="Agda">
<a id="Type"></a><a id="1885" href="Universes.html#1885" class="Function">Type</a> <a id="1890" class="Symbol">=</a> <a id="1892" class="Symbol">λ</a> <a id="1894" href="Universes.html#1894" class="Bound">ℓ</a> <a id="1896" class="Symbol">→</a> <a id="1898" class="PrimitiveType">Set</a> <a id="1902" href="Universes.html#1894" class="Bound">ℓ</a>

<a id="_̇"></a><a id="1905" href="Universes.html#1905" class="Function Operator">_̇</a>   <a id="1910" class="Symbol">:</a> <a id="1912" class="Symbol">(</a><a id="1913" href="Universes.html#1913" class="Bound">𝓤</a> <a id="1915" class="Symbol">:</a> <a id="1917" href="Universes.html#408" class="Postulate">Universe</a><a id="1925" class="Symbol">)</a> <a id="1927" class="Symbol">→</a> <a id="1929" href="Universes.html#1885" class="Function">Type</a> <a id="1934" class="Symbol">(</a><a id="1935" href="Universes.html#1913" class="Bound">𝓤</a> <a id="1937" href="Agda.Primitive.html#627" class="Primitive Operator">⁺</a><a id="1938" class="Symbol">)</a>

<a id="1941" href="Universes.html#1941" class="Bound">𝓤</a> <a id="1943" href="Universes.html#1905" class="Function Operator">̇</a>  <a id="1946" class="Symbol">=</a> <a id="1948" href="Universes.html#1885" class="Function">Type</a> <a id="1953" href="Universes.html#1941" class="Bound">𝓤</a>
</pre>

This says that given the universe level `𝓤`, we get the type universe
`𝓤 ̇`&nbsp;, which lives in the next next type universe universe `𝓤 ⁺`. So
the superscript dot notation is just a (postfix) synonym for (prefix)
`Type`, which is just a synonym for `Set`, which means type in Agda.

We name a few of the initial universes:

<pre class="Agda">
<a id="𝓤₁"></a><a id="2306" href="Universes.html#2306" class="Function">𝓤₁</a> <a id="2309" class="Symbol">=</a> <a id="2311" href="Universes.html#611" class="Primitive">𝓤₀</a> <a id="2314" href="Agda.Primitive.html#627" class="Primitive Operator">⁺</a>
<a id="𝓤₂"></a><a id="2316" href="Universes.html#2316" class="Function">𝓤₂</a> <a id="2319" class="Symbol">=</a> <a id="2321" href="Universes.html#2306" class="Function">𝓤₁</a> <a id="2324" href="Universes.html#627" class="Primitive Operator">⁺</a>
<a id="𝓤₃"></a><a id="2326" href="Universes.html#2326" class="Function">𝓤₃</a> <a id="2329" class="Symbol">=</a> <a id="2331" href="Universes.html#2316" class="Function">𝓤₂</a> <a id="2334" href="Universes.html#627" class="Primitive Operator">⁺</a>
</pre>

The following is sometimes useful:

<pre class="Agda">
<a id="universe-of"></a><a id="2397" href="Universes.html#2397" class="Function">universe-of</a> <a id="2409" class="Symbol">:</a> <a id="2411" class="Symbol">{</a><a id="2412" href="Universes.html#2412" class="Bound">𝓤</a> <a id="2414" class="Symbol">:</a> <a id="2416" href="Universes.html#408" class="Postulate">Universe</a><a id="2424" class="Symbol">}</a> <a id="2426" class="Symbol">(</a><a id="2427" href="Universes.html#2427" class="Bound">X</a> <a id="2429" class="Symbol">:</a> <a id="2431" href="Universes.html#2412" class="Bound">𝓤</a> <a id="2433" href="Universes.html#1905" class="Function Operator">̇</a> <a id="2435" class="Symbol">)</a> <a id="2437" class="Symbol">→</a> <a id="2439" href="Agda.Primitive.html#408" class="Postulate">Universe</a>
<a id="2448" href="Universes.html#2397" class="Function">universe-of</a> <a id="2460" class="Symbol">{</a><a id="2461" href="Universes.html#2461" class="Bound">𝓤</a><a id="2462" class="Symbol">}</a> <a id="2464" href="Universes.html#2464" class="Bound">X</a> <a id="2466" class="Symbol">=</a> <a id="2468" href="Universes.html#2461" class="Bound">𝓤</a>
</pre>

Fixities:

<pre class="Agda">
<a id="2506" class="Keyword">infix</a>  <a id="2513" class="Number">1</a> <a id="2515" href="Universes.html#1905" class="Function Operator">_̇</a>
</pre>

[<sub>Table of contents ⇑</sub>](HoTT-UF-Agda.html#contents)
