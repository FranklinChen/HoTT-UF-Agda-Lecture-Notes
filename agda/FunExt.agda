{-# OPTIONS --without-K --exact-split --safe #-}

module FunExt where

open import Universes
open import MLTT-Agda
open import HoTT-UF-Agda

funext : ∀ 𝓤 𝓥 → (𝓤 ⊔ 𝓥)⁺ ̇
funext 𝓤 𝓥 = {X : 𝓤 ̇ } {Y : 𝓥 ̇ } {f g : X → Y} → f ∼ g → f ≡ g

transport-is-pre-comp : (ua : is-univalent 𝓤) {X Y Z : 𝓤 ̇ } (e : X ≃ Y) (g : Y → Z)
                      → transport (λ - → - → Z) ((Eq-to-Id ua X Y e)⁻¹) g ≡ g ∘ Eq-to-fun e

transport-is-pre-comp ua {X} {Y} {Z} e g = α e (Eq-to-Id ua X Y e) (refl (Eq-to-Id ua X Y e))
 where
  α : (e : X ≃ Y) (p : X ≡ Y)
    → p ≡ Eq-to-Id ua X Y e
    → transport (λ - → - → Z) (p ⁻¹) g ≡ g ∘ Eq-to-fun e
  α e (refl X) = γ
   where
    γ : refl X ≡ Eq-to-Id ua X X e → g ≡ g ∘ Eq-to-fun e
    γ q = ap (g ∘_) b
     where
      a : ≃-refl X ≡ e
      a = ≃-refl X                         ≡⟨ ap (Id-to-Eq X X) q ⟩
          Id-to-Eq X X (Eq-to-Id ua X X e) ≡⟨ inverse-is-section (Id-to-Eq X X) (ua X X) e ⟩
          e                                ∎
      b : id ≡ Eq-to-fun e
      b = ap Eq-to-fun a

pre-comp-is-equiv : (ua : is-univalent 𝓤) {X Y Z : 𝓤 ̇ } (f : X → Y)
                  → is-equiv f
                  → is-equiv (λ (g : Y → Z) → g ∘ f)
pre-comp-is-equiv ua {X} {Y} {Z} f i = j
 where
  e : X ≃ Y
  e = (f , i)

  of-course : Eq-to-fun e ≡ f
  of-course = refl f

  φ γ : (Y → Z) → (X → Z)
  φ g = g ∘ f
  γ g = transport (λ - → - → Z) ((Eq-to-Id ua X Y e)⁻¹) g

  γ-is-equiv : is-equiv γ
  γ-is-equiv = transport-is-equiv (λ - → - → Z) ((Eq-to-Id ua X Y e)⁻¹)

  h' : (g : Y → Z) → transport (λ - → - → _) ((Eq-to-Id ua X Y e)⁻¹) g ≡ g ∘ Eq-to-fun e
  h' = transport-is-pre-comp ua e

  h : γ ∼ φ
  h = h'

  j : is-equiv φ
  j = equivs-closed-under-∼' γ φ γ-is-equiv h

pre-comp-is-equiv' : (ua : is-univalent 𝓤) {X Y Z : 𝓤 ̇ } (f : X → Y)
                   → is-equiv f
                   → is-equiv (λ (g : Y → Z) → g ∘ f)
pre-comp-is-equiv' ua {X} {Y} {Z} f i =
 equivs-closed-under-∼'
  (transport (λ - → - → Z) ((Eq-to-Id ua X Y (f , i))⁻¹))
  (_∘ f)
  (transport-is-equiv (λ - → - → Z) ((Eq-to-Id ua X Y (f , i))⁻¹))
  (transport-is-pre-comp ua (f , i))

univalence-gives-funext : is-univalent 𝓤 → funext 𝓥 𝓤
univalence-gives-funext ua {X} {Y} {f₀} {f₁} h = γ
 where
  Δ = Σ \(y₀ : Y) → Σ \(y₁ : Y) → y₀ ≡ y₁

  δ : Y → Δ
  δ y = (y , y , refl y)

  π₀ π₁ : Δ → Y
  π₀ (y₀ , y₁ , p) = y₀
  π₁ (y₀ , y₁ , p) = y₁

  δ-is-equiv : is-equiv δ
  δ-is-equiv = invertibles-are-equivs δ (π₀ , η , ε)
   where
    η : (y : Y) → π₀ (δ y) ≡ y
    η y = refl y
    ε : (d : Δ) → δ (π₀ d) ≡ d
    ε (y , y , refl y) = refl (y , y , refl y)

  πδ : π₀ ∘ δ ≡ π₁ ∘ δ
  πδ = refl id

  φ : (Δ → Y) → (Y → Y)
  φ π = π ∘ δ

  φ-is-equiv : is-equiv φ
  φ-is-equiv = pre-comp-is-equiv ua δ δ-is-equiv

  π₀-equals-π₁ : π₀ ≡ π₁
  π₀-equals-π₁ = equivs-are-lc φ φ-is-equiv πδ

  γ : f₀ ≡ f₁
  γ = ap (λ π x → π (f₀ x , f₁ x , h x)) π₀-equals-π₁

  γ' = f₀                              ≡⟨ refl _ ⟩
       (λ x → f₀ x)                    ≡⟨ refl _ ⟩
       (λ x → π₀ (f₀ x , f₁ x , h x))  ≡⟨ ap (λ π x → π (f₀ x , f₁ x , h x)) π₀-equals-π₁ ⟩
       (λ x → π₁ (f₀ x , f₁ x , h x))  ≡⟨ refl _ ⟩
       (λ x → f₁ x)                    ≡⟨ refl _ ⟩
       f₁                              ∎

dfunext : ∀ 𝓤 𝓥 → 𝓤 ⁺ ⊔ 𝓥 ⁺ ̇
dfunext 𝓤 𝓥 = {X : 𝓤 ̇ } {A : X → 𝓥 ̇ } {f g : Π A} → f ∼ g → f ≡ g

happly : {X : 𝓤 ̇ } {A : X → 𝓥 ̇ } (f g : Π A) → f ≡ g → f ∼ g
happly f g p x = ap (λ - → - x) p

hfunext : ∀ 𝓤 𝓥 → 𝓤 ⁺ ⊔ 𝓥 ⁺ ̇
hfunext 𝓤 𝓥 = {X : 𝓤 ̇ } {A : X → 𝓥 ̇ } (f g : Π A) → is-equiv (happly f g)

hfunext-gives-dfunext : hfunext 𝓤 𝓥 → dfunext 𝓤 𝓥
hfunext-gives-dfunext hfe {X} {A} {f} {g} = inverse (happly f g) (hfe f g)

vvfunext : ∀ 𝓤 𝓥 → 𝓤 ⁺ ⊔ 𝓥 ⁺ ̇
vvfunext 𝓤 𝓥 = {X : 𝓤 ̇ } {A : X → 𝓥 ̇ } → ((x : X) → is-singleton (A x)) → is-singleton (Π A)

dfunext-gives-vvfunext : dfunext 𝓤 𝓥 → vvfunext 𝓤 𝓥
dfunext-gives-vvfunext fe {X} {A} i = f , c
 where
  f : Π A
  f x = center (A x) (i x)
  c : (g : Π A) → f ≡ g
  c g = fe (λ (x : X) → centrality (A x) (i x) (g x))

post-comp-is-invertible : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } {A : 𝓦 ̇ }
                        → funext 𝓦 𝓤 → funext 𝓦 𝓥
                        → (f : X → Y) → invertible f → invertible (λ (h : A → X) → f ∘ h)
post-comp-is-invertible {𝓤} {𝓥} {𝓦} {X} {Y} {A} nfe nfe' f (g , η , ε) = (g' , η' , ε')
 where
  f' : (A → X) → (A → Y)
  f' h = f ∘ h
  g' : (A → Y) → (A → X)
  g' k = g ∘ k
  η' : (h : A → X) → g' (f' h) ≡ h
  η' h = nfe (η ∘ h)
  ε' : (k : A → Y) → f' (g' k) ≡ k
  ε' k = nfe' (ε ∘ k)

post-comp-is-equiv : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } {A : 𝓦 ̇ } → funext 𝓦 𝓤 → funext 𝓦 𝓥
                   → (f : X → Y) → is-equiv f → is-equiv (λ (h : A → X) → f ∘ h)
post-comp-is-equiv fe fe' f e = invertibles-are-equivs
                                 (λ h → f ∘ h)
                                 (post-comp-is-invertible fe fe' f (equivs-are-invertible f e))

vvfunext-gives-hfunext : vvfunext 𝓤 𝓥 → hfunext 𝓤 𝓥
vvfunext-gives-hfunext {𝓤} {𝓥} vfe {X} {Y} f = γ
 where
  a : (x : X) → is-singleton (Σ \(y : Y x) → f x ≡ y)
  a x = singleton-types-are-singletons' (Y x) (f x)
  c : is-singleton ((x : X) → Σ \(y : Y x) → f x ≡ y)
  c = vfe a
  R : (Σ \(g : Π Y) → f ∼ g) ◁ (Π \(x : X) → Σ \(y : Y x) → f x ≡ y)
  R = ≃-gives-▷ _ _ ΠΣ-distr-≃
  r : (Π \(x : X) → Σ \(y : Y x) → f x ≡ y) → Σ \(g : Π Y) → f ∼ g
  r = λ _ → f , (λ x → refl (f x))
  d : is-singleton (Σ \(g : Π Y) → f ∼ g)
  d = retract-of-singleton R c
  e : (Σ \(g : Π Y) → f ≡ g) → (Σ \(g : Π Y) → f ∼ g)
  e = NatΣ (happly f)
  i : is-equiv e
  i = maps-of-singletons-are-equivs (Σ (λ g → f ≡ g)) (Σ (λ g → f ∼ g)) e
       (singleton-types-are-singletons' (Π Y) f) d
  γ : (g : Π Y) → is-equiv (happly f g)
  γ = NatΣ-equiv-gives-fiberwise-equiv (λ g → f ≡ g) (λ g → f ∼ g) (happly f) i

funext-gives-vvfunext : funext 𝓤 (𝓤 ⊔ 𝓥) → funext 𝓤 𝓤 → vvfunext 𝓤 𝓥
funext-gives-vvfunext {𝓤} {𝓥} fe fe' {X} {A} φ = retract-of-singleton (r , s , rs) i
  where
   f : Σ A → X
   f = pr₁
   f-is-equiv : is-equiv f
   f-is-equiv = pr₁-equivalence X A φ
   g : (X → Σ A) → (X → X)
   g h = f ∘ h
   g-is-equiv : is-equiv g
   g-is-equiv = post-comp-is-equiv fe fe' f f-is-equiv
   i : is-singleton (Σ \(h : X → Σ A) → f ∘ h ≡ id)
   i = g-is-equiv id
   r : (Σ \(h : X → Σ A) → f ∘ h ≡ id) → Π A
   r (h , p) x = transport A (happly (f ∘ h) id p x) (pr₂ (h x))
   s : Π A → (Σ \(h : X → Σ A) → f ∘ h ≡ id)
   s φ = (λ x → x , φ x) , refl id
   rs : ∀ φ → r (s φ) ≡ φ
   rs φ = refl (r (s φ))

funext-gives-hfunext : funext 𝓤 (𝓤 ⊔ 𝓥) → funext 𝓤 𝓤 → hfunext 𝓤 𝓥
funext-gives-hfunext fe fe' = vvfunext-gives-hfunext (funext-gives-vvfunext fe fe')

funext-gives-dfunext : funext 𝓤 (𝓤 ⊔ 𝓥) → funext 𝓤 𝓤 → dfunext 𝓤 𝓥
funext-gives-dfunext fe fe' = hfunext-gives-dfunext (funext-gives-hfunext fe fe')

univalence-gives-hfunext' : is-univalent 𝓤 → is-univalent (𝓤 ⊔ 𝓥) → hfunext 𝓤 𝓥
univalence-gives-hfunext' ua ua' = funext-gives-hfunext
                                     (univalence-gives-funext ua')
                                     (univalence-gives-funext ua)

univalence-gives-vvfunext' : is-univalent 𝓤 → is-univalent (𝓤 ⊔ 𝓥) → vvfunext 𝓤 𝓥
univalence-gives-vvfunext' ua ua' = funext-gives-vvfunext
                                     (univalence-gives-funext ua')
                                     (univalence-gives-funext ua)

univalence-gives-hfunext : is-univalent 𝓤 → hfunext 𝓤 𝓤
univalence-gives-hfunext ua = univalence-gives-hfunext' ua ua

univalence-gives-dfunext : is-univalent 𝓤 → dfunext 𝓤 𝓤
univalence-gives-dfunext ua = hfunext-gives-dfunext (univalence-gives-hfunext ua)

univalence-gives-vvfunext : is-univalent 𝓤 → vvfunext 𝓤 𝓤
univalence-gives-vvfunext ua = univalence-gives-vvfunext' ua ua

Π-is-subsingleton : dfunext 𝓤 𝓥 → {X : 𝓤 ̇ } {A : X → 𝓥 ̇ }
                  → ((x : X) → is-subsingleton (A x))
                  → is-subsingleton (Π A)
Π-is-subsingleton fe i f g = fe (λ x → i x (f x) (g x))

being-a-singleton-is-a-subsingleton : dfunext 𝓤 𝓤 → {X : 𝓤 ̇ }
                                    → is-subsingleton (is-singleton X)
being-a-singleton-is-a-subsingleton fe {X} (x , φ) (y , γ) = p
 where
  i : is-subsingleton X
  i = singletons-are-subsingletons X (y , γ)
  s : is-set X
  s = subsingletons-are-sets X i
  p : (x , φ) ≡ (y , γ)
  p = to-Σ-≡ (φ y , fe (λ (z : X) → s y z _ _))

being-an-equiv-is-a-subsingleton : dfunext 𝓥 (𝓤 ⊔ 𝓥) → dfunext (𝓤 ⊔ 𝓥) (𝓤 ⊔ 𝓥)
                                 → {X : 𝓤 ̇ } {Y : 𝓥 ̇ } (f : X → Y)
                                 → is-subsingleton (is-equiv f)
being-an-equiv-is-a-subsingleton fe fe' f =
 Π-is-subsingleton fe (λ x → being-a-singleton-is-a-subsingleton fe')

univalence-is-a-subsingleton : is-univalent (𝓤 ⁺) → is-subsingleton (is-univalent 𝓤)
univalence-is-a-subsingleton {𝓤} ua⁺ ua ua' = p
 where
  fe₀ : funext 𝓤 𝓤
  fe₀ = univalence-gives-funext ua
  fe₁ : funext 𝓤 (𝓤 ⁺)
  fe₁ = univalence-gives-funext ua⁺
  fe₂ : funext (𝓤 ⁺) (𝓤 ⁺)
  fe₂ = univalence-gives-funext ua⁺
  dfe₁ : dfunext 𝓤 (𝓤 ⁺)
  dfe₁ = funext-gives-dfunext fe₁ fe₀
  dfe₂ : dfunext (𝓤 ⁺) (𝓤 ⁺)
  dfe₂ = funext-gives-dfunext fe₂ fe₂

  i : is-subsingleton (is-univalent 𝓤)
  i = Π-is-subsingleton dfe₂
       (λ X → Π-is-subsingleton dfe₂
               (λ Y → being-an-equiv-is-a-subsingleton dfe₁ dfe₂ (Id-to-Eq X Y)))

  p : ua ≡ ua'
  p = i ua ua'

global-univalence : 𝓤ω
global-univalence = ∀ 𝓤 → is-univalent 𝓤

univalence-is-a-subsingletonω : global-univalence → is-subsingleton (is-univalent 𝓤)
univalence-is-a-subsingletonω {𝓤} γ = univalence-is-a-subsingleton (γ (𝓤 ⁺))

univalence-is-a-singleton : global-univalence → is-singleton (is-univalent 𝓤)
univalence-is-a-singleton {𝓤} γ = pointed-subsingletons-are-singletons
                                   (is-univalent 𝓤)
                                   (γ 𝓤)
                                   (univalence-is-a-subsingletonω γ)

being-a-subsingleton-is-a-subsingleton : {X : 𝓤 ̇ } → dfunext 𝓤 𝓤
                                       → is-subsingleton (is-subsingleton X)
being-a-subsingleton-is-a-subsingleton {𝓤} {X} fe i j = c
 where
  l : is-set X
  l = subsingletons-are-sets X i
  a : (x y : X) → i x y ≡ j x y
  a x y = l x y (i x y) (j x y)
  b : (x : X) → i x ≡ j x
  b x = fe (a x)
  c : i ≡ j
  c = fe b

Π-is-set : hfunext 𝓤 𝓥 → {X : 𝓤 ̇ } {A : X → 𝓥 ̇ }
         → ((x : X) → is-set(A x)) → is-set(Π A)
Π-is-set hfe s f g = b
 where
  a : is-subsingleton (f ∼ g)
  a p q = hfunext-gives-dfunext hfe ((λ x → s x (f x) (g x) (p x) (q x)))
  b : is-subsingleton(f ≡ g)
  b = equiv-to-subsingleton (happly f g) (hfe f g) a

being-set-is-a-subsingleton : dfunext 𝓤 𝓤 → {X : 𝓤 ̇ } → is-subsingleton (is-set X)
being-set-is-a-subsingleton {𝓤} fe {X} =
 Π-is-subsingleton fe
   (λ x → Π-is-subsingleton fe
           (λ y → being-a-subsingleton-is-a-subsingleton fe))

hlevel-relation-is-subsingleton : dfunext 𝓤 𝓤
                                → (n : ℕ) (X : 𝓤 ̇ ) → is-subsingleton (X is-of-hlevel n)
hlevel-relation-is-subsingleton {𝓤} fe zero     X = being-a-singleton-is-a-subsingleton fe
hlevel-relation-is-subsingleton {𝓤} fe (succ n) X =
  Π-is-subsingleton fe
    (λ x → Π-is-subsingleton fe
            (λ x' → hlevel-relation-is-subsingleton {𝓤} fe n (x ≡ x')))

●-assoc : dfunext 𝓣 (𝓤 ⊔ 𝓣) → dfunext (𝓤 ⊔ 𝓣) (𝓤 ⊔ 𝓣)
        → {X : 𝓤 ̇ } {Y : 𝓥 ̇ } {Z : 𝓦 ̇ } {T : 𝓣 ̇ }
          (α : X ≃ Y) (β : Y ≃ Z) (γ : Z ≃ T)
        → α ● (β ● γ) ≡ (α ● β) ● γ
●-assoc fe fe' (f , a) (g , b) (h , c) = to-Σ-≡ (p , q)
 where
  p : (h ∘ g) ∘ f ≡ h ∘ (g ∘ f)
  p = refl (h ∘ g ∘ f)

  d e : is-equiv (h ∘ g ∘ f)
  d = ∘-is-equiv (∘-is-equiv c b) a
  e = ∘-is-equiv c (∘-is-equiv b a)

  q : transport is-equiv p d ≡ e
  q = being-an-equiv-is-a-subsingleton fe fe' (h ∘ g ∘ f) _ _

inversion-involutive : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } (f : X → Y) (e : is-equiv f)
                     → inverse (inverse f e) (inverse-is-equiv f e) ≡ f
inversion-involutive f e = refl f

≃-sym-involutive : dfunext 𝓥 (𝓤 ⊔ 𝓥) → dfunext (𝓥 ⊔ 𝓤) (𝓥 ⊔ 𝓤) →
                   {X : 𝓤 ̇ } {Y : 𝓥 ̇ } (α : X ≃ Y)
                 → ≃-sym (≃-sym α) ≡ α
≃-sym-involutive fe fe' (f , a) = to-Σ-≡ (inversion-involutive f a ,
                                          being-an-equiv-is-a-subsingleton fe fe' f _ _)

