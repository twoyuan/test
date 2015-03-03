<?php
// 本类由系统自动生成，仅供测试用途
namespace Home\Controller;
use Think\Controller;
class IndexController extends Controller {
    public function index(){
		//sendMail('s_p_teng@sina.com','测试','测试2');
    }
	public function regist(){
		if(IS_POST) {
			$model=D('Member');
			
			if($model->create()) {
				
				if($model->add()) {
					$this->success('邮件已发送请验证',U('lst'));
				}else {
					$sql=$model->getLastSql();
					$this->error($sql);
				}
			}else {
				$error=$this->getError();
				$this->error($error);
			}
		}

		$this->display();
	}
	public function checkCode($code) {
		$model=D('Member');
		$user=$model->where("email_code='$code'")->find();
		if($user) {
			$ex=C('MAIL_EXPRISE_TIME');
			if(time()-$user['email_time']<=$ex) {
				$model->where("email_code='$code'")->setField('email_code','');
				$this->success('验证成功',U('login'));
				exit;
			}else {
				header("Content-Type:text/html;charset=utf-8");
				die("验证码过期<a href='".U('resend',array('code'=>$code))."'>重新发送验证码</a>");
				exit;
			}
		}else{
			die('验证码无效');
		}
	}
	public function resend($code) {
		$model=D('Member');
		$user=$model->where("email_code='$code'")->find();
		if($user['email_code']!='') {
			$newcode=uniqid();
			$model->where('id='.$user['id'])->save(array(
					'email_code'=>$newcode,
					'email_time'=>time(),
				));
			$model->_sendMail($user['email'],$newcode);
			die('邮件已发送，请查收');
		}else {
			die('该会员以验证');
		}
	}

	public function login() {
		if(IS_POST) {
			$model=D('Member');
			if($model->create()) {
				$ret=$model->login();
				if($ret===true) {
					redirect('/');exit;
				}elseif($ret==1) {
					$this->error('必须先验证才能登陆');
				}elseif($ret==2) {
					$this->error('用户名或者密码错误');
				}
			}
		}
		$this->display();
	}
	public function goods() {
		$this->display();
	}


}