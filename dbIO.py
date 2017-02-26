import mysql.connector

def getConnection():
	return mysql.connector.connect(user='root', password=' ',
                            host='localhost',
                            database='hack_bu')

def getCursor(connection):
	return connection.cursor()

#Returns true if username is valid.
def validateUsername(username, connection):
	cursor = getCursor(connection)
	query = "SELECT username FROM user WHERE username = %s"
	cursor.execute (query, (username,))
	value = cursor.fetchall()
	connection.commit()
	cursor.close()
	if (len(value) > 0):
		return False
	return True

#Returns 0 if failed.
#Returns 1 if successful.
def createUser(name, username, password, user_id, connection):
	if (validateUsername(username, connection)):
		cursor = getCursor(connection)
		# execute the SQL query using execute() method.
		cursor.execute ("INSERT INTO user VALUES (%s, %s, %s, %s);", (name, username, password, user_id))
		connection.commit()

		# close the cursor object
		cursor.close()
		# close connection to SQL db
		connection.close()
		return 1
	return 0

def createTeam(user_id, group_id, connection):
	cursor = getCursor(connection)
	user_score = 0
	# execute the SQL query using execute() method.
	cursor.execute("INSERT INTO team VALUES (%s, %s, %s, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);", (group_id, user_id, user_score))
	connection.commit()
	# close the cursor object
	cursor.close()
	# close connection to SQL db
	connection.close()
	return 1


#***************************************************************************
#***************************************************************************

def getUserScore(user_id, group_id, connection):
	col_name = getColName(user_id, group_id, connection)
	score_index = "score" + findNextScore(col_name)
	cursor = getCursor(connection)
	query = "SELECT " + score_index + " FROM team WHERE group_id = %s"
	cursor.execute (query, (group_id,))
	value = cursor.fetchall()
	connection.commit()
	return value[0][0]

# Returns COLUMN NAME based off of the user_id and group_id.
def getColName(user_id, group_id, connection):
	users = ['user1', 'user2', 'user3', 'user4', 'user5', 'user6', 'user7', 'user8']
	cursor = getCursor(connection)
	for i in range(len(users)):
		if (getColNameHelper(users[i], group_id, connection, cursor) == user_id):
			return "user" + str(i+1)
	return None

def getColNameHelper(user, group_id, connection, cursor):
	# execute the SQL query using execute() method.
	query = "SELECT " + user + " FROM team WHERE group_id = %s"
	cursor.execute (query, (group_id,))
	# fetch all of the rows from the query
	value = cursor.fetchall()
	connection.commit()
	return value[0][0]

def updateUserScore(user_id, group_id, connection, cursor):3
	col_name = getColName(user_id, group_id, connection)
	score_index = "score" + findNextScore(col_name)
	new_score = getUserScore(user_id, group_id, connection) + 1

	query = "UPDATE team SET " + score_index + " = %s WHERE group_id = %s"

	cursor.execute (query, (new_score, group_id))

	connection.commit()

def registerFire(shooter_id, shootee_id, group_id, video_link, connection):
	cursor = getCursor(connection)
	# Update video table.
	cursor.execute ("INSERT INTO video VALUES (%s, %s, %s, %s);", (shooter_id, shootee_id, group_id, video_link))
	connection.commit()
	# Update user score.
	updateUserScore(shooter_id, group_id, connection, cursor)
	# close the cursor object
	cursor.close()
	# close connection to SQL db
	connection.close()

#***************************************************************************
#***************************************************************************


#***************************************************************************
#***************************************************************************
def findNextUser(group_id, connection):
	cursor = getCursor(connection)
	users = ['user1', 'user2', 'user3', 'user4', 'user5', 'user6', 'user7', 'user8']
	values = []
	for user in users:
		values.append(findNextUserHelper(user, group_id, connection, cursor))
	for i in range(len(values)):
		if values[i] == None:
			return users[i]
	return None

def findNextUserHelper(user, group_id, connection, cursor):
	# execute the SQL query using execute() method.
	query = "SELECT " + user + " FROM team WHERE group_id = %s"
	cursor.execute (query, (group_id,))
	# fetch all of the rows from the query
	value = cursor.fetchall()
	connection.commit()
	return value[0][0]

def findNextScore(next_user):
	return next_user.split('user')[1]

def addUserToGroup(user_id, group_id, connection):
	cursor = getCursor(connection)
	next_user = findNextUser(group_id, connection)
	next_score = "score" + findNextScore(next_user)
	# execute the SQL query using execute() method.
	query = "UPDATE team SET " + next_user + " = %s, " + next_score + " = %s WHERE group_id = %s"

	cursor.execute(query, (user_id, 0, group_id))

	connection.commit()
	# close the cursor object
	cursor.close()
	# close connection to SQL db
	connection.close()

#***************************************************************************
#***************************************************************************

def main():
	connection = getConnection()
	cursor = getCursor(connection)

	name1 = "Tyler Schmitt"
	username1 = "schmittj"
	password1 = "abc123"
	user_id1 = 'zzz0101'
	group_id1 = 'OVO2017'
	video_link1 = "https://www.youtube.com/nerf1"

	name2 = "Annika Wiesenger"
	username2 = "awies"
	password2 = "4ab4ab"
	user_id2 = 'aaa0101'
	group_id2 = 'OVO1999'
	video_link2 = "https://www.youtube.com/nerf2"

	#validateUsername(username1, connection)
	#createUser(name2, username2, password2, user_id2, connection)
	#createTeam(user_id2, group_id2, connection)
	#registerFire(user_id1, user_id2, group_id1, video_link1, connection)
	#addUserToGroup(user_id2, group_id1, connection)

main()