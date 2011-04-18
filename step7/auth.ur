table user : { Id : int, Username : string, Password : string, Email : string }
	PRIMARY KEY Id

cookie userSession : {Username : string, Password : string}

fun ifAuthenticated page row =
	re' <- oneOrNoRows(SELECT user.Id, 
									  user.Username, 
									  user.Password 
							   FROM user 
							  WHERE user.Username = {[row.Username]} 
							    AND user.Password = {[row.Password]});
	case re' of
		None => error <xml>Invalid Login</xml>
	 | Some re => 
	  		setCookie userSession 
					{Value = {Username = readError re.User.Username, 
								 Password = readError re.User.Password},
                Expires = None,
                Secure = True};
					 page
			
fun loginHandler row = 
	ifAuthenticated (return <xml>
				<head><title>Logged in!</title></head>
				<body>
					<h1>Logged in</h1>
				</body>
			</xml>) row

fun displayIfAuthenticated page =
	c <- getCookie userSession;
	case c of
		None => return 
			<xml><head/>
				<body>
				<h1>Not logged in.</h1>
				<p><a link={login()}>Login</a></p>
				</body>
			</xml>
	 | Some c' => ifAuthenticated page c'

and login () = return
	<xml>
		<head><title>Login to UrBlog</title></head>
		<body>
			<form>
				<p>Username:<br/><textbox{#Username}/><br/>
				   Password:<br/><password{#Password}/><br/>
					<submit value="Login" action={loginHandler}/>
				</p>
			</form>
		</body>
	</xml>
