<h2>マイページ</h2>
<p>ようこそ {{ $user->name }} さん</p>

<form method="POST" action="{{ route('logout') }}">
  @csrf
  <button type="submit">ログアウト</button>
</form>
