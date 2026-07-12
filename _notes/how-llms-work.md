---
title: "How LLMs Work, From Scratch"
date: 2026-07-12
last_modified_at: 2026-07-12
tags: [ai, llms]
---

<div class="how-llms-work-post" markdown="1">

<p>When ChatGPT launched in late 2022, it opened a whole new set of possibilities for what computers can do. Fast forward to today, AI has already started contributing to the world in many ways, from writing code to speeding up scientific progress. Over the past few years AI models have kept getting better, and so has everything you can do with them.</p>

<p>And yet, most of us still don't know how this technology actually works.</p>

<p>A Large language model, is simply just a mathematical function: given some input text, it predicts the probability of what word comes next. <a href="https://sambharia.com/learn-ai">I wanted to understand how LLMs work from scratch</a>, not to become an expert, but to understand the basics of this technology.</p>

<p>In this post, I've broken down every step of how LLMs work from scratch, stripping away the complexity. By the end, you should have a simple mental model for how LLMs work fundamentally.</p>

<div class="toc">
<p><strong>The roadmap:</strong></p>
<ol>
  <li><strong>Tokenization</strong>: text becomes integers</li>
  <li><strong>Embedding</strong>: integers become vectors with meaning and position</li>
  <li><strong>Attention</strong>: tokens read each other</li>
  <li><strong>MLP</strong>: each token thinks, and facts get stored</li>
  <li><strong>LayerNorm and residuals</strong>: plumbing that keeps it stable</li>
  <li><strong>The full forward pass</strong>: every piece wired together, and the vector becomes the next token</li>
  <li><strong>Inference</strong>: the model uses that next-token prediction to generate text, one token at a time</li>
</ol>
</div>

## 1. Tokenization

<p>LLMs are mathematical functions; <strong>they don't understand words</strong>. We need a way to convert words to integers using a process called Tokenization.</p>

<ol>
  <li>Tokenization breaks down text into smaller units called <strong>tokens</strong>.</li>
  <li>Each token is then mapped to a numerical value (Token-ID) that the model can process.</li>
</ol>

<p>For instance: take a small dataset of 500 US names. You can map all characters in the alphabet to an integer:</p>

<table>
  <thead>
    <tr><th>Token ID</th><th>Character</th></tr>
  </thead>
  <tbody>
    <tr><td>0</td><td>a</td></tr>
    <tr><td>1</td><td>b</td></tr>
    <tr><td>2</td><td>c</td></tr>
    <tr><td>&hellip;</td><td>&hellip;</td></tr>
    <tr><td>25</td><td>z</td></tr>
    <tr><td>26</td><td><em>special token</em></td></tr>
  </tbody>
</table>

<p>Now any name is a list of integers. <code>SID &rarr; [19, 8, 3]</code>, <code>JOHN &rarr; [10, 15, 8, 14]</code>.</p>

<p>This was a simple example, but in today's LLMs, instead of mapping each character to a token ID, models use subword tokenization techniques. Why?</p>

<ol>
  <li>Human language is fairly complex. Splitting tokens into subwords lets the model handle words it never saw in training by assembling them from pieces.</li>
  <li>Models don't use character-to-token mapping because it makes sequences long and slow to compute.</li>
</ol>

<p>Currently, Frontier Labs uses <strong><em>subword</em></strong> tokenization techniques like <a href="https://www.perplexity.ai/search/what-is-byte-pair-encoding-bpe-MV_w_T17RWG6sZUqRl2pIA">Byte Pair Encoding (BPE)</a>. BPE starts with individual characters and iteratively merges the most frequent pairs of symbols to form new tokens.</p>

<figure>
  <img src="{{ site.baseurl }}/assets/how-llms-work/tokenization.svg" alt="The word symbiosis split into subword tokens sym, bio, sis and their token IDs" style="max-width: 70%;" />
  <figcaption style="max-width: 70%; margin-left: auto; margin-right: auto;">Subword tokenization: &ldquo;symbiosis&rdquo; splits into tokens, each mapped to a token ID</figcaption>
</figure>

<p>Alongside the regular tokens in the dataset, models add tokens for structure.</p>

<ul>
  <li><strong>BOS</strong> (beginning of sequence) sits at the start, so the first real token has something before it to look at.</li>
  <li><strong>EOS</strong> (end of sequence) sits at the end. During inference, producing an EOS is the signal to stop. Without it, the model runs forever.</li>
</ul>

<p>Some models use one token for both jobs. For example, a name will be represented as <code>[BOS, S, I, D, EOS]</code></p>

<p>The model now has a predefined vocabulary of words with an integer value attached to each entry.</p>

## 2. Embedding: giving tokens meaning

<p>Token IDs are <strong>arbitrary integers</strong>; they don't have any meaning.</p>

<p><code>a = 0, b = 1</code>&hellip;</p>

<p>The numbers mean nothing by themselves. We need a way to give meaning to these tokens.</p>

<p>Embeddings fix this.</p>

<blockquote>Picture a library where each book (words) has a barcode (token-ID) stuck on it. The barcode says nothing about the book. What you actually want is a description: topic: food, difficulty: easy, language: english. An embedding is that description, written as a vector of numbers.</blockquote>

<p>Embedding is a <strong>learned vector of numbers that stores information about the token</strong>, for the model to do math on it.</p>

<h3>Word-Token-Embedding</h3>

<p>Every model keeps an <strong>embedding matrix</strong>. Every token ID has a vector associated with it. For instance, take a small vocabulary with a 3-dimensional embedding vector; an embedding matrix for it looks like this (showing just a few tokens):</p>

<table>
  <thead>
    <tr><th>Token ID</th><th>Token</th><th>Embedding vector</th></tr>
  </thead>
  <tbody>
    <tr><td>0</td><td>"cat"</td><td><code>[0.9, 0.1, 0.8]</code></td></tr>
    <tr><td>1</td><td>"kitten"</td><td><code>[0.85, 0.15, 0.75]</code></td></tr>
    <tr><td>2</td><td>"car"</td><td><code>[0.1, 0.9, 0.2]</code></td></tr>
  </tbody>
</table>

<figure>
  <img src="{{ site.baseurl }}/assets/how-llms-work/embedding-space.svg" alt="Scatter plot of the embedding vectors: cat, dog and kitten cluster as animals; car and truck cluster as vehicles" style="max-width: 70%;" />
  <figcaption style="max-width: 70%; margin-left: auto; margin-right: auto;">Tokens with similar meaning land close together in embedding space</figcaption>
</figure>

<p>For instance, in this example you can see:</p>

<p>&ldquo;cat&rdquo; <code>[0.9, 0.1, 0.8]</code> and &ldquo;kitten&rdquo; <code>[0.85, 0.15, 0.75]</code> are very close in the 3-D space. While &ldquo;car&rdquo; <code>[0.1, 0.9, 0.2]</code> is far away, even though its ID (2) is right next to cat's (0).</p>

<p>The embedding vector encodes <strong>meaning</strong> about the token that is learned in the training process. Maybe the first dimension captures &ldquo;animal-ness,&rdquo; the second &ldquo;vehicle-ness.&rdquo; Nobody set them by hand. The model learned them.</p>

<p>Because the vectors hold meaning, something surprising happens. After training, you can do meaningful arithmetic on tokens:</p>

<blockquote><code>vec("king") - vec("man") + vec("woman") &approx; vec("queen")</code></blockquote>

<p>Nobody coded that. It fell out of training.</p>

<p>This embedding matrix is called <strong>WTE</strong> (word token embedding) matrix. The dimension of the WTE matrix is (no. of token IDs, dimension of embedding), which is <code>(50257, 768)</code> for GPT-2.</p>

<h3>Word-Position-Embedding</h3>

<p>Let's take two sentences:</p>

<blockquote>&ldquo;The dog bit the man&rdquo;<br />&ldquo;The man bit the dog&rdquo;</blockquote>

<p>Both snippets have the same tokens, but <strong>the order of tokens changes the meaning completely</strong>.</p>

<p>The embedding vector for &ldquo;man&rdquo; in both cases is the same. We need a way to add the positional meaning to each vector.</p>

<p>The fix is a second matrix, <strong>WPE</strong> (word position embedding).</p>

<p>For instance, take a model with a context window (the maximum tokens an AI model can process in a single request) of 5 tokens, with a 3-dimensional position embedding vector; the WPE looks like this:</p>

<table>
  <thead>
    <tr><th>Position</th><th>Position vector</th></tr>
  </thead>
  <tbody>
    <tr><td>0</td><td><code>[0.00, 0.10, 0.00]</code></td></tr>
    <tr><td>1</td><td><code>[0.30, 0.20, 0.40]</code></td></tr>
    <tr><td>2</td><td><code>[0.10, 0.40, 0.60]</code></td></tr>
    <tr><td>3</td><td><code>[0.85, 0.12, 0.50]</code></td></tr>
    <tr><td>4</td><td><code>[0.15, 0.45, 0.75]</code></td></tr>
  </tbody>
</table>

<p>The dimension of the embedding vector is (context window &times; dimension of embedding vector). GPT-2's WPE is <code>(1024, 768)</code>.</p>

<p>The input to the next transformer block is just the two added together:</p>

<pre><code>X&#8271 = WTE[token]  (what it is)
   + WPE[i]      (where it sits)</code></pre>

<p>For &ldquo;dog&rdquo; sitting in position 1, the final embedding vector that gets passed to the next stage is:</p>

<pre><code>X(dog) = [0.8, 0.2, 0.7]   (its WTE embedding)
       + [0.0, 0.1, 0.0]   (the position-1 vector from WPE)</code></pre>

<p>Now &ldquo;dog&rdquo; in position 2 and &ldquo;dog&rdquo; in position 5 look different, and word order finally means something.</p>

## 3. Attention

<p>Now we have an input X per token that encodes its meaning and position.</p>

<p>Consider this example:</p>

<blockquote>&ldquo;She walked to the river <strong>bank</strong> to fish.&rdquo;<br />&ldquo;She called her investment <strong>bank</strong> about the loan.&rdquo;</blockquote>

<p>The token &lsquo;bank&rsquo; has the exact same embedding vector, but <strong>it means completely different things in both examples</strong>. A fixed vector can't be both a riverbank and a financial one.</p>

<p>The model needs a way to update its vector to encode information from its surroundings. If the token &lsquo;bank&rsquo; is near &ldquo;river&rdquo; and &ldquo;fish,&rdquo; it should lean geographic.</p>

<p>It's the job of the Attention Block in the Transformer where <strong>the tokens communicate with each other to update their values based on context</strong>. Figure out which earlier tokens are relevant and what to add to X(bank) to produce a refined X&prime;(bank) that encodes the meaning of the words that came before it.</p>

<p>Attention is the trickiest concept to wrap your head around in this blog. Let's take the phrase &ldquo;<em>her investment bank</em>&rdquo;. Here's how Attention works in 3 parts:</p>

<ol>
  <li><strong>Query (Q)</strong>: &ldquo;bank&rdquo; asks, who can help me predict the next token.</li>
  <li><strong>Key (K)</strong>: every other token before &lsquo;bank&rsquo; in the model's context presents its offer.</li>
  <li><strong>Value (V)</strong>: the actual information the other tokens in context hand over once picked.</li>
</ol>

<p>Now the mechanics.</p>

<p>Attention introduces three learned matrices, <strong>W<sub>q</sub>, W<sub>k</sub>, W<sub>v</sub></strong>, and each token multiplies its <code>X</code> by them to produce three vectors.</p>

<p>A quick note before we dive in: an <strong>attention head</strong> is just one independent copy of this whole Q, K, V machinery. A model runs many heads in parallel, each learning to look for a different kind of relationship.</p>

<blockquote>
<p><strong>Note</strong></p>
<p>A <strong>dot product</strong> is a single number that measures how much two lists of numbers agree. You multiply them position by position and add it up, so <code>[1, 2]</code> and <code>[3, 1]</code> give <code>3 + 2 = 5</code>. The idea is that a bigger number means the two lists are more alike, which is how a token measures how relevant another token is to it.</p>
<p><strong>Softmax</strong> is a function that converts raw scores into probabilities. It takes any list of numbers like <code>[1, -2, 3]</code> and turns it into a distribution like <code>[0.12, 0.01, 0.88]</code>, where every value sits between 0 and 1 and they all sum to 1. Crucially, it preserves the relative order: the highest score stays the highest and the lowest stays the lowest, so nothing gets reshuffled, it just gets rescaled into "how much attention goes to each token."</p>
</blockquote>

<p><strong>Step 1: Project into Q, K, V.</strong></p>

<p>Every token's embedding vector X(bank) gets multiplied by three learned weight matrices, W<sub>q</sub>, W<sub>k</sub>, W<sub>v</sub>, each of size <code>(embedding dimension &times; head dimension)</code>, e.g. in GPT-2, each head's matrices are <code>(768 &times; 64)</code>:</p>

<pre><code>Query = X &middot; Wq
Key   = X &middot; Wk
Value = X &middot; Wv</code></pre>

<p>We calculate the Q, K, V vectors for every token in the context.</p>

<p><strong>Step 2: Compute attention scores</strong>: take the dot product of each Query with every Key to get a score matrix:</p>

<table class="matrix-table">
  <thead>
    <tr><th class="corner">Q &#92; K</th><th>her</th><th>investment</th><th>bank</th></tr>
  </thead>
  <tbody>
    <tr><td class="rowlabel">her</td><td>2</td><td>0</td><td>1</td></tr>
    <tr><td class="rowlabel">investment</td><td>0</td><td>2</td><td>1</td></tr>
    <tr><td class="rowlabel">bank</td><td class="followed">1</td><td class="followed">3</td><td class="followed">1</td></tr>
  </tbody>
</table>
<p class="note">The highlighted row is the one we follow, the Query "bank" against every Key.</p>

<p>For &ldquo;bank&rdquo;, the raw scores are <code>[1, 3, 1]</code>: it aligns strongly with &ldquo;investment&rdquo;, weakly with &ldquo;her&rdquo; and with itself.</p>

<p><strong>Step 3: Scale</strong>: these scores can get large, so we divide by &radic;(d<sub>k</sub>), the square root of the head dimension &mdash; the length of each Q/K/V vector. In this toy example each head is 3-dimensional, so d<sub>k</sub> = 3 and &radic;(d<sub>k</sub>) = &radic;3 = 1.73. This keeps gradients stable.</p>

<pre><code>[1, 3, 1]  &rarr; &divide; &radic;(d<sub>k</sub>) = &divide;&radic;3 &rarr;  [0.57, 1.73, 0.57]</code></pre>

<p><strong>Step 4: Convert to probabilities</strong>: run the scaled scores through softmax so they sum to 1.</p>

<pre><code>[0.57, 1.73, 0.57]  &rarr; softmax &rarr;  [0.2, 0.6, 0.2]</code></pre>

<figure>
  <img src="{{ site.baseurl }}/assets/how-llms-work/attention-weights.svg" alt="Attention weight matrix for her investment bank, with future tokens masked" style="max-width: 70%;" />
  <figcaption style="max-width: 70%; margin-left: auto; margin-right: auto;">Each row shows how one query token splits its attention over the keys it can see; the &ldquo;bank&rdquo; row is the <code>[0.2, 0.6, 0.2]</code> from above</figcaption>
</figure>

<p><strong>Step 5: Weighted sum of Values</strong>: multiply each token's Value vector by its attention weight and sum:</p>

<pre><code>0.2 &times; V("her") + 0.6 &times; V("investment") + 0.2 &times; V("bank") = new context-aware vector for "bank"</code></pre>

<p>The whole thing in one line:</p>

<pre><code>Attention(Q, K, V) = softmax(Q &middot; K&#7488; / &radic;dk) &middot; V</code></pre>

<p>Before attention, &ldquo;bank&rdquo; was just &ldquo;bank&rdquo;, the same vector in a riverbank sentence or a finance one. After, it's &ldquo;bank, mostly shaped by &lsquo;investment&rsquo;,&rdquo; already leaning financial before the model predicts a single word. The vector wasn't replaced. It got <strong>nudged</strong> toward the meaning its neighbors imply.</p>

### Causal Masking (No peeking)

<p>There's one flaw in Attention. A token may only <strong>attend</strong> to itself and what came before it. Otherwise it's cheating. We enforce this by setting future scores to negative infinity before softmax (e<sup>-&infin;</sup> = 0), which makes their probability zero:</p>

<table class="matrix-table">
  <thead>
    <tr><th class="corner">Q &#92; K</th><th>her</th><th>investment</th><th>bank</th></tr>
  </thead>
  <tbody>
    <tr><td class="rowlabel">her</td><td>0</td><td class="masked">&minus;&infin;</td><td class="masked">&minus;&infin;</td></tr>
    <tr><td class="rowlabel">investment</td><td>0</td><td>0</td><td class="masked">&minus;&infin;</td></tr>
    <tr><td class="rowlabel">bank</td><td>1</td><td>3</td><td>1</td></tr>
  </tbody>
</table>

<p>&ldquo;her&rdquo; sees only itself. &ldquo;investment&rdquo; sees &ldquo;her&rdquo; and itself. &ldquo;bank&rdquo; sees everything before it. <strong>Every token predicts using only the past</strong>, exactly as it will when generating for real.</p>

### Multi-head attention

<p>One head learns one kind of relationship. Language has many at once, so we run several in parallel, each with its own W<sub>q</sub>, W<sub>k</sub>, W<sub>v</sub>, each hunting a different pattern.</p>

<p>The trick is to split the vector into equal chunks, one per head, instead of handing each head the full width. In GPT-2, for example, a 768-dimension embedding vector X splits across 12 heads, taking 64 dimensions each.</p>

<p>Take a 4-dimension X(bank) vector with 2 heads:</p>

<pre><code>"bank": [0.9, 0.1, 0.8, 0.2]
Head 1: [0.9, 0.1]      Head 2: [0.8, 0.2]</code></pre>

<p>Each head runs the five steps above on its own slice. One might lean on grammar (&ldquo;bank&rdquo; is a singular subject), the other on meaning (&ldquo;bank&rdquo; is related to finance). Say they come back with:</p>

<pre><code>Head 1 &rarr; [0.67, 0.67]
Head 2 &rarr; [0.16, 0.58]</code></pre>

<p>Glue them back together, up to full width again (4 here):</p>

<pre><code>[0.67, 0.67, 0.16, 0.58]</code></pre>

<p>One last matrix, <strong>W<sub>o</sub></strong>, mixes the glued heads together to get the final result.</p>

<pre><code>[0.67, 0.67, 0.16, 0.58] &times; Wo = [0.8, 1.1, 0.4, 0.9]   &larr; final attention output for "bank"</code></pre>

## 4. Feed Forward Network (MLP)

<p>The next block is the <strong>MLP</strong> (or feed-forward network), this is the part where LLMs store facts. In the previous step, the token &lsquo;bank&rsquo; gathered context from the surrounding tokens, but it still hasn't reasoned through it.</p>

<p>Knowing &ldquo;river is near&rdquo; and &ldquo;bank is near&rdquo; isn't the same as concluding &ldquo;this is geography.&rdquo; To reason over the fact that river + bank = riverbank, models need a thinking layer, and that's where MLPs help.</p>

<p><strong>MLP stands for multilayer perceptron.</strong> In this layer, each token's embedding vector goes through a series of operations where it expands to a larger dimension first and then compresses back to its initial dimension.</p>

<p>Unlike the previous step where each token &lsquo;attends&rsquo; to one another, in this step <strong>each token thinks on its own</strong>. No token talks to another here; they all run the same operation in parallel.</p>

<p>Here's the working:</p>

<ol>
  <li><strong>Expand (W<sub>1</sub>).</strong> Blow the vector up into a bigger space (GPT-2 goes 768 &rarr; 3072) by multiplying it with the W<sub>1</sub> matrix.</li>
  <li><strong>Apply a nonlinearity</strong> like GeLU, ReLU, etc.<br />The simplest nonlinear function example is <strong>ReLU</strong>, which just zeroes out negatives and passes positives through: <code>[0.8, 1.4, -0.2, 2.1]</code> (ReLU) &rarr; <code>[0.8, 1.4, 0, 2.1]</code></li>
  <li><strong>Compress (W<sub>2</sub>).</strong> Multiply by the W<sub>2</sub> matrix to shrink back to the original size.</li>
</ol>

<p>Mathematically:</p>

<pre><code>MLP(x) = W2 &middot; GELU(W1x + b1) + b2</code></pre>

<figure>
  <img src="{{ site.baseurl }}/assets/how-llms-work/mlp-v1.svg" alt="MLP: input vector expands via W1, a nonlinearity turns neurons on or off, then W2 compresses back" />
  <figcaption>W<sub>1</sub> expands the vector, the nonlinearity switches neurons on/off, W<sub>2</sub> compresses back</figcaption>
</figure>

<p>A nice way to read it: each row of W<sub>1</sub> asks one question (&ldquo;is this river + bank?&rdquo;). The answer after the nonlinearity is a <strong>neuron</strong>: positive for yes, zero for no. Each column of W<sub>2</sub> is the response to add back when that neuron fires. When &ldquo;riverbank&rdquo; lights up, W<sub>2</sub> stamps &ldquo;geography, water, landscape&rdquo; onto the token.</p>

<p>This is also where <strong>facts live</strong>. Most of a model's parameters sit in these layers, not in attention, and they aren't generic bookkeeping. Researchers have found single neurons that fire on the Eiffel Tower, or on past-tense verbs, or on a specific programming language. When a model &ldquo;knows&rdquo; Paris is the capital of France, that fact is spread across FFN weights in particular layers.</p>

## 5. LayerNorm and Residuals

<p>Two pieces of plumbing keep a deep stack trainable.</p>

<p><strong>LayerNorm.</strong> After a few blocks, a token's numbers drift. Some hit 500, others 0.001. Softmax hates that (<code>[500, 501, 499]</code> collapses to nearly <code>[0, 1, 0]</code>), and training goes unstable. LayerNorm rescales each token's vector to mean 0 and spread 1, keeping the pattern but taming the scale. <code>[10, 2, 6, 14]</code> becomes <code>[0.45, -1.34, -0.45, 1.34]</code> Notice how the relative pattern is preserved but the scale is tamed.</p>

<p><strong>Residuals.</strong> Each block adds its output back onto its input instead of replacing it:</p>

<pre><code>new = old + block(old)</code></pre>

<p>Without this, a later block can wipe out what an earlier one figured out, and &ldquo;bank&rdquo; could forget it was ever &ldquo;bank.&rdquo; With it, the original rides along and each block only has to add a small nudge. A block with nothing useful to contribute can output roughly 0 and get skipped for free.</p>

<p> For instance, &ldquo;cat&rdquo;'s vector is <code>[0.8, 0.3]</code> and attention produces the update <code>[0.0, 1.1]</code>:</p>

<ul>
  <li><strong>Without residual:</strong> new vector = <code>[0.0, 1.1]</code>, the <code>0.8</code> is gone forever, unrecoverable by later blocks.</li>
  <li><strong>With residual:</strong> new vector = <code>[0.8, 0.3] + [0.0, 1.1] = [0.8, 1.4]</code>, the original survives, new context layered on top.</li>
</ul>

<p>Residuals also save training. A deep stack has to send a correction signal backward from the last block to the first, and without a shortcut that signal fades to nothing on the way. This is the <strong>vanishing gradient problem.</strong> The residual is a clean path straight through, so early layers still learn. More on that in part 2.</p>


<p> LayerNorm and Residuals are added after each block to keep the model trainable.</p>

## 6. The Full Forward Pass

<p>We've built every piece on its own. Now let's wire them together and watch a single token make the whole trip.</p>

<p>One <strong>forward pass</strong> is just text going in one end and a prediction coming out the other. Tokenize the text, look up each token's meaning and position, then push the stack through the transformer blocks: attention lets the tokens read each other, the MLP reasons over what they gathered, and LayerNorm and residuals keep the whole thing stable. That block repeats over and over (12 times in GPT-2), each pass layering a little more context onto every token.</p>

<figure>
  <img src="{{ site.baseurl }}/assets/how-llms-work/pipeline.svg" alt="End-to-end LLM pipeline: text, tokenizer, token IDs, embedding lookup, positional encoding, transformer block repeated N times, unembedding, softmax, next token" style="width: 100%; max-width: 100%; max-height: none;" />
  <figcaption>The full path from text to the next token, every stage of this post in one picture</figcaption>
</figure>

<p>We've followed a token all the way from tokenization through the transformer blocks. Out the far end comes a refined vector <strong>X&prime;</strong>, loaded with all the context it gathered along the way. But X&prime; is still just a list of numbers. We need to turn it back into words and predict the next token, the job we started with. Three steps do it:</p>

<ol>
  <li><strong>A final LayerNorm.</strong> One last rescale to tidy up the vector. We're still left with a 768-dimensional embedding vector (in GPT-2), the same shape we started with back in the embedding step.</li>
  <li><strong>The language-model head (LM head).</strong> To get from a vector back to words, we do the reverse of embedding: embedding turned a token ID into a vector, now we turn a vector into a score for every token in the vocabulary. We don't even need a brand-new matrix, the head is usually the <strong>embedding matrix (WTE) transposed</strong>, a <code>(768 &times; vocab)</code> matrix reused in reverse. Multiplying X&prime; by it gives one raw score per token. Those scores are the <strong>logits</strong>.</li>
  <li><strong>Softmax.</strong> Turn the logits into probabilities that sum to 1. That's the probability table from the top of the post.</li>
</ol>

<p>Back to our sentence, &ldquo;She called her investment ___&rdquo;. The LM head turns X&prime; into one logit per token in the vocabulary, and softmax turns those into probabilities:</p>

<table class="matrix-table">
  <thead>
    <tr><th>Token</th><th>Logit</th><th>Probability</th></tr>
  </thead>
  <tbody>
    <tr><td class="followed">bank</td><td class="followed">3.4</td><td class="followed">0.61</td></tr>
    <tr><td>firm</td><td>2.4</td><td>0.23</td></tr>
    <tr><td>advisor</td><td>1.6</td><td>0.10</td></tr>
    <tr><td>account</td><td>0.5</td><td>0.03</td></tr>
    <tr><td>loan</td><td>-0.2</td><td>0.02</td></tr>
    <tr><td>broker</td><td>-0.4</td><td>0.01</td></tr>
  </tbody>
</table>

<p>The model is most confident the next word is <strong>bank</strong>. One logit per token, squashed into one probability per token, and the highest one is the model's best guess. (The names model works the same way, just with <code>vocab = 27</code>, one score for each letter a to z plus the end token.)</p>

<p>Here's the whole forward pass in code:</p>

<pre><code>def gpt(token_ids, positions):
    x = wte[token_ids] + wpe[positions]   # embed: what + where

    for block in blocks:                  # 12 blocks in GPT-2
        x = x + attn(layer_norm(x))       # gather context (+ residual)
        x = x + mlp(layer_norm(x))        # reason over it (+ residual)

    x = layer_norm_final(x)
    return lm_head(x)                     # logits over the vocabulary</code></pre>

<p>That's the forward pass. Embed the tokens, alternate attention and MLP a dozen times, project back to the vocabulary. Every section above is one line here.</p>

## Inference

<p>The model scores every position at once, but when generating we only care about the last one: the prediction for the next token.</p>

<p><strong>Generation is a loop.</strong> Predict a token, stick it on the end, run again.</p>

<pre><code>"She called her investment" &rarr; "bank"
"She called her investment bank" &rarr; "about"
...</code></pre>

<p>How you pick from the distribution is a choice:</p>

<ul>
  <li><strong>Greedy</strong>: always take the top token. Deterministic, often dull.</li>
  <li><strong>Temperature</strong>: divide the logits by T before softmax. Below 1 sharpens the odds (safer), above 1 flattens them (wilder).</li>
  <li><strong>Top-k / top-p</strong>: sample only from the top k tokens, or from the smallest set of tokens covering probability p.</li>
</ul>

<figure>
<svg viewBox="0 0 720 380" role="img"
     aria-label="The inference loop: input tokens go through the GPT forward pass to predict the next token; if it is the end-of-sequence token the loop stops, otherwise the token is appended and the loop repeats"
     style="width:100%;height:auto;max-width:680px;display:block;margin:1.4em auto;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;">
  <defs>
    <marker id="ilArrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse">
      <path d="M0,0 L10,5 L0,10 z" fill="#555"/>
    </marker>
  </defs>

  <rect x="1" y="1" width="718" height="378" rx="16" fill="#fbfbfa" stroke="#e2e2e2"/>

  <!-- 1. Input -->
  <rect x="45" y="52" width="130" height="56" rx="10" fill="#fff" stroke="#2f5d9f" stroke-width="1.5"/>
  <text x="110" y="76" text-anchor="middle" font-size="13" fill="#9a9a9a" font-weight="600">1. INPUT</text>
  <text x="110" y="96" text-anchor="middle" font-size="15" fill="#1a1a1a">tokens</text>

  <!-- 2. GPT block -->
  <rect x="255" y="52" width="150" height="56" rx="10" fill="#eaf1fb" stroke="#2f5d9f" stroke-width="1.5"/>
  <text x="330" y="76" text-anchor="middle" font-size="13" fill="#2f5d9f" font-weight="600">2. GPT BLOCK</text>
  <text x="330" y="96" text-anchor="middle" font-size="15" fill="#1a1a1a">forward pass</text>

  <!-- 3. Output / next token -->
  <rect x="480" y="52" width="160" height="56" rx="10" fill="#fff" stroke="#2f5d9f" stroke-width="1.5"/>
  <text x="560" y="76" text-anchor="middle" font-size="13" fill="#9a9a9a" font-weight="600">3. OUTPUT</text>
  <text x="560" y="96" text-anchor="middle" font-size="15" fill="#1a1a1a">next token</text>

  <!-- EOS decision diamond -->
  <polygon points="560,158 622,200 560,242 498,200" fill="#fff7e6" stroke="#c69214" stroke-width="1.5"/>
  <text x="560" y="205" text-anchor="middle" font-size="15" fill="#1a1a1a" font-weight="600">EOS?</text>

  <!-- Stop -->
  <rect x="490" y="292" width="140" height="52" rx="10" fill="#e9f5ee" stroke="#2f7d5f" stroke-width="1.5"/>
  <text x="560" y="323" text-anchor="middle" font-size="15" fill="#2f7d5f" font-weight="600">4. Stop</text>

  <!-- arrows: main flow -->
  <line x1="175" y1="80" x2="249" y2="80" stroke="#555" stroke-width="1.6" marker-end="url(#ilArrow)"/>
  <line x1="405" y1="80" x2="474" y2="80" stroke="#555" stroke-width="1.6" marker-end="url(#ilArrow)"/>
  <line x1="560" y1="108" x2="560" y2="152" stroke="#555" stroke-width="1.6" marker-end="url(#ilArrow)"/>

  <!-- yes -> stop -->
  <line x1="560" y1="242" x2="560" y2="286" stroke="#555" stroke-width="1.6" marker-end="url(#ilArrow)"/>
  <text x="574" y="270" font-size="13" fill="#2f7d5f" font-weight="600">Yes</text>

  <!-- no -> loop back to input -->
  <polyline points="498,200 110,200 110,114" fill="none" stroke="#555" stroke-width="1.6" marker-end="url(#ilArrow)"/>
  <text x="300" y="192" text-anchor="middle" font-size="13" fill="#c26a1b" font-weight="600">No &mdash; append token &amp; repeat</text>
</svg>
<figcaption style="max-width: 680px; margin-left: auto; margin-right: auto;">The inference loop: run the forward pass, take the predicted token, stop on EOS, otherwise append it and run again</figcaption>
</figure>

<p>You stop when the model emits EOS, or when you hit a length cap. The names model samples letters (<code>s</code>, <code>a</code>, <code>m</code>) until it emits the end token, and you've got a fresh name.</p>

## What Next?

<p>It took decades of breakthroughs in computer science to finally build AI, and there's still so much left to do. What we covered here is just the foundation, there's a lot more to how LLMs work, at scale and in optimization, that I didn't get into. But hopefully these basics open up the vast ocean of things you can now go learn from.</p>

<p>The best next step is to see all of this in code. Go read <a href="https://karpathy.github.io/2026/02/12/microgpt/">microGPT</a>, the whole thing running in a couple hundred lines of Python.</p>

<p>If you found this helpful, reach out on <a href="https://x.com/sambharia">X</a>. I'd love your feedback, and I love making new friends.</p>

<p>This post was inspired by <a href="https://karpathy.github.io/2026/02/12/microgpt/">Karpathy's microGPT</a> and <a href="https://karpathy.github.io/">blog</a>, <a href="https://leerob.com/ai">Lee Robinson's Understanding AI</a>, and <a href="https://www.0xkato.xyz/how-llms-actually-work/">0xkato's How LLMs Actually Work</a>.</p>

</div>

<style>
  .how-llms-work-post .toc {
    background: #f4f4f2;
    border: 1px solid #e2e2e2;
    border-radius: 8px;
    padding: 20px 24px;
  }
  .how-llms-work-post .toc ol { margin: 0; padding-left: 1.2em; }
  .how-llms-work-post table {
    border-collapse: collapse;
    width: 100%;
    margin: 1.5em 0;
    font-size: 0.95em;
  }
  .how-llms-work-post th,
  .how-llms-work-post td {
    border: 1px solid #e2e2e2;
    padding: 8px 12px;
    text-align: center;
  }
  .how-llms-work-post th {
    background: #f0f0ee;
    font-weight: 600;
  }
  .how-llms-work-post td.rowlabel,
  .how-llms-work-post th.corner {
    background: #f7f7f5;
    font-weight: 600;
  }
  .how-llms-work-post .matrix-table td.masked {
    color: #b5b5b5;
  }
  .how-llms-work-post .matrix-table td.followed {
    background: #fff4d6;
    font-weight: 600;
  }
  .how-llms-work-post .note {
    font-size: 0.9em;
    color: #555;
  }
  .how-llms-work-post figcaption {
    text-align: center;
    font-size: 0.85em;
    color: #555;
    margin-top: -0.6em;
    margin-bottom: 1.4em;
  }
  .how-llms-work-post pre {
    background: #f4f4f2;
    border: 1px solid #e2e2e2;
    border-radius: 8px;
    padding: 16px 18px;
    overflow-x: auto;
    font-size: 0.92em;
  }
  .how-llms-work-post pre code {
    background: none;
    padding: 0;
  }
</style>
