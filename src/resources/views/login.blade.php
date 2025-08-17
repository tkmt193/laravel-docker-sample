<h2>ログイン</h2>
<form method="POST" action="/login">
  @csrf
  <input type="email" name="email" placeholder="メール"><br>
  <input type="password" name="password" placeholder="パスワード"><br>
  <button type="submit">ログイン</button>
</form>
<a href="/register">新規登録はこちら</a>
