
numDic={'A':'1','B':'2','C':'3','D':'A'
	,'E':'4','F':'5','G':'6','H':'B'
	,'I':'7','J':'8','K':'9','L':'C'
	,'M':'*','N':'0','O':'#','P':'D'}

def index(req):
	message=''
	req.content_type = 'text/html'
	numFile = open("/var/www/html/keypadNum.txt", "r")
	number = numFile.readline()
	numFile.close()
	number=numDic[number[0]]
	message += "<p>Last Pressed Key is:<b> %s</b></p>" % (number)
	return message

