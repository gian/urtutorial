table entry : { Id : int, Title : string, Created : time, Author : string, Body : string }
  PRIMARY KEY Id

table comment : {Id : int, Entry : int, Created : time, Author : string, Body : string }
	PRIMARY KEY Id,
	CONSTRAINT Entry FOREIGN KEY Entry REFERENCES entry(Id)

style blogEntry
style blogComment

fun comments i : transaction xbody =
	queryX (SELECT * FROM comment WHERE comment.Entry = {[i]})
		(fn row =>
			<xml>
				<div class={blogComment}>
					<p>{[row.Comment.Body]}</p>
					<p>By {[row.Comment.Author]} at {[row.Comment.Created]}</p>
				</div>
			</xml>)

fun list () =
    rows <- queryX (SELECT * FROM entry)
            (fn row => 
				<xml>
					<div class={blogEntry}>
						<h1><a link={detail row.Entry.Id}>{[row.Entry.Title]}</a></h1>
							<h2>By {[row.Entry.Author]} at {[row.Entry.Created]}</h2>
						<p>{[row.Entry.Body]}</p>
					</div>
				</xml>
            );
    return 
	 	<xml>
		  <head>
				<title>All Entries</title>
				<link rel="stylesheet" type="text/css" href="https://github.com/gian/urtutorial/raw/master/step4/style.css"/>
		  </head>
		  <body>
			<h1>All Entries</h1>
        {rows}
		  </body>
    	</xml>

and detail (i:int) =
	res <- oneOrNoRows (SELECT * FROM entry WHERE entry.Id = {[i]});
	comm <- comments i;
	return
	(case res of
		None => <xml>
					<head><title>Entry Not Found</title></head>
					<body>
						<h1>Entry not found</h1>
					</body>
				  </xml>
	 | Some r => <xml>
						<head>
							<title>{[r.Entry.Title]}</title>
							<link rel="stylesheet" type="text/css" href="https://github.com/gian/urtutorial/raw/master/step4/style.css"/>
						</head>
						<body>
						<h1>{[r.Entry.Title]}</h1>
						<div class={blogEntry}>
						<h2>By {[r.Entry.Author]} at {[r.Entry.Created]}</h2>
						<p>{[r.Entry.Body]}</p>
						</div>
						{comm}
						<a link={list ()}>Back to all entries</a>
						</body>
					 </xml>)

fun main () = return <xml>
  <head>
    <title>UrBlog</title>
  </head>

  <body>
    <h1>UrBlog</h1>
  </body>
</xml>
