<?php 
namespace Home\Model;
use Think\Model;

class MemberModel extends Model {
	protected $_validate = array(
		
	);
	protected function _before_insert(&$data,$option) {
		
		$data['password'] = md5($data['password']);
		$data['email_code'] = uniqid();
		$data['email_time'] = time();
		
	}
	protected function _after_insert($data,$option) {

		$this->_sendMail($data['email'],$data['email_code']);
	}
	public function _sendMail($add,$code) {
		sendMail($add,'验证码',"请点击以下链接完成验证：<br/><a href='http://www.song.com/index.php/Home/Index/checkCode/code/{$code}'>http://www.song.com/index.php/Home/Index/checkCode/code/{$code}</a><br/>");
	}

	public function login () {
		$password = $this->password;
		$user = $this->where("username='{$this->username}'")->find();
		
		if($user) {
			if($user['email_code']!='') {
				return 1;
			}
			if($user['password']!=md5($password)) {
				return 2;
			}
			session('id',$user['id']);
			session('username',$user['username']);
			$loginInfo = I('post.remember');
			if($loginInfo) {
				$des_key=C('DES_KEY');
				$un = \Think\Crypt::encrypt($user['username'],$des_key);
				$pd = \Think\Crypt::encrypt($password,$des_key);
				$aMonth=24*3600*30;
				setCookie('username',$un,time()+$aMonth,'/','www.song.com');
				setCookie('password',$pd,time()+$aMonth,'/','www.song.com');
			}
			return true;
		}else 
			return 2;
	}
}