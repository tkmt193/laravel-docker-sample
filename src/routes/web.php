<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

Route::get('/', function () {
    return view('welcome');
});
Route::get('/login', function () { return view('login'); });
Route::post('/login', [AuthController::class, 'login']);

Route::get('/register', function () { return view('register'); });
Route::post('/register', [AuthController::class, 'register']);

Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

Route::get('/mypage', [AuthController::class, 'mypage'])->middleware('auth');
