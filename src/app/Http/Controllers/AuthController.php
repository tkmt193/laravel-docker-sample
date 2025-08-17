<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    // サインイン（新規登録）
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:6',
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        Auth::login($user);
        return redirect('/mypage');
    }

    // ログイン
    public function login(Request $request)
    {
        $credentials = $request->only('email', 'password');

        if (Auth::attempt($credentials)) {
            return redirect('/mypage');
        }

        return back()->withErrors(['email' => 'ログイン失敗しました']);
    }

    // ログアウト
    public function logout()
    {
        Auth::logout();
        return redirect('/login');
    }

    // マイページ
    public function mypage()
    {
        return view('mypage', ['user' => Auth::user()]);
    }
}
