/*
 Hello world!
*/

Timer g_timer;
Timer s_timer;
Timer d_timer;
string VelStr;
vector2 VelVec;
float HP;
uint lastKeyDir2;
vector2 bulletMoveDir;


#include "eth_util.angelscript"
#include "Collide.angelscript"
#include "force.angelscript"

void main()
{
	LoadScene("scenes/scene01.esc", "onCreate", "onUpdate");

	// Prefer setting window properties in the app.enml file
	// SetWindowProperties("Ethanon Engine", 1024, 768, true, true, PF32BIT);
}


void onCreate()
{
	ETHEntity@ thisEntity = SeekEntity("spark.ent");
	thisEntity.SetFloat("HP",100);
	HP = thisEntity.GetFloat("HP");
	uint bgblue = ARGB(225,155,230,244);
	SetBackgroundColor(bgblue);
	s_timer.start();
	
	 

}


void onUpdate()
{
	ETHEntity@ thisEntity = SeekEntity("spark.ent");
	ETHPhysicsController @body = thisEntity.GetPhysicsController();
	vector2 currentPos = thisEntity.GetPositionXY();
	bool touchingGround = (thisEntity.GetUInt("touchingGround") != 0);
	//thisEntity.SetFloat("HP",HP);
	VelVec = body.GetLinearVelocity();
	VelStr = vector2ToString(VelVec);
	

	DrawFadingText(vector2(100,0),"Test: " + vector2ToString(getCurrentForce(thisEntity)) + "\n " + vector2ToString(currentPos) + "\n" + touchingGround + "\n" + GetTime() + "\n" + thisEntity.GetFloat("HP"),"Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);

}

void ETHCallback_flyEnm(ETHEntity@ thisEntity)
{
	ETHPhysicsController @body = thisEntity.GetPhysicsController();
	ETHEntity@ spark = SeekEntity("spark.ent");
	

	if (s_timer.getElapsedTime() < 2500)
		{

			body.SetLinearVelocity(normalize(vector2(-0.9f, -0.5f)));
			//print("plus" + getTimeString(s_timer.getElapsedTime()));
			
		}

	if (s_timer.getElapsedTime() >= 2500 && s_timer.getElapsedTime() <= 4500)
		{

			body.SetLinearVelocity(normalize(vector2(0.9f, 0.5f)));
			//print("minus" + getTimeString(s_timer.getElapsedTime()));
			
		}
	if (s_timer.getElapsedTime() > (5000 + rand(500)))
		{

			s_timer.reset();
			//print("reset" + getTimeString(s_timer.getElapsedTime()));

		}

		if (thisEntity.GetFloat("dead") == 1)
		{
			DeleteEntity(thisEntity);
			addHP(spark,10);
		}



}



void ETHCallback_bullet(ETHEntity@ thisEntity)
{

	vector2 dire = bulletMoveDir;
    float speed = UnitsPerSecond(500.0f);
	thisEntity.AddToPositionXY(dire * speed);







	//ETHPhysicsController @body = thisEntity.GetPhysicsController();
	/*float speed = UnitsPerSecond(100.0f);
	ETHPhysicsController @body = thisEntity.GetPhysicsController();

	//thisEntity.AddToPositionXY(normalize(bulletDir(thisEntity)) * speed);
	body.SetLinearVelocity(normalize(bulletDir(thisEntity)) * speed);
	if (thisEntity.GetFloat("dead") == 1)
		{
			DeleteEntity(thisEntity);
		}*/

}

void ETHCallback_spark(ETHEntity@ thisEntity)
{
	ETHInput @input = GetInputHandle();
	ETHPhysicsController @body = thisEntity.GetPhysicsController();
	//ETHEntity@ bullet = SeekEntity("bullet.ent");

	SetCameraPos(thisEntity.GetPositionXY() - (GetScreenSize() / 2.0f));
	const float textSize = 25.0f;
	vector2 moveDirection(0,0);
	moveDirection = KeyboardInput();
	vector2 currentPos = thisEntity.GetPositionXY();
	float speed = UnitsPerSecond(500.0f);
	float dash = UnitsPerSecond(1000.0f);
	float sparkX;
	float sparkY;
	string strDirX;
	string strDirY;


	
	thisEntity.SetFloat("maxJumps",2);
	collisionBox thisBox = thisEntity.GetCollisionBox();
	thisBox.pos += (thisEntity.GetPosition() - vector3(0,20,0));
	//thisBox.pos += thisEntity.GetPosition();
	
	thisEntity.SetFloat("forceX", moveDirection.x);
	//thisEntity.SetFloat("forceY", moveDirection.y);

	sparkX = thisEntity.GetFloat("forceX");
	sparkY = thisEntity.GetFloat("forceY");

	
	if (moveDirection.x > 0)
		strDirX = "RIGHT";

	if (moveDirection.x < 0)
		strDirX = "LEFT";

	if (moveDirection.x == 0)
		strDirX = "N/A";

/* remove only this to uncomment!

	if (moveDirection.y < 0)
		{
			DrawFadingText(vector2(300,300),"< 0","Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);
			thisEntity.SetUInt("touchingGround", 0);
			strDirY = "UP";
		}
	if (moveDirection.y == 0)
		{
			DrawFadingText(vector2(300,300),"= 0","Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);
			strDirY = "DOWN";
			
		}
	/*if (CollideStatic(thisEntity))
		{
			thisEntity.SetUInt("touchingGround", 1);
		}*/

	if (thisEntity.CheckCustomData("elapsedTime") == DT_NODATA)
		{
			thisEntity.SetUInt("elapsedTime", 0);
			//thisEntity.AddToUInt("elapsedTime", GetLastFrameElapsedTime());
		}

	if (thisEntity.CheckCustomData("invin") == DT_NODATA)
		{
			thisEntity.SetUInt("invin", 0);
		}

	/*if (thisEntity.GetInt("invin") > 0)
		{
			print("Start Damage Timer");
			d_timer.start();
		}*/
	if (d_timer.getElapsedTime() >= 2000)
		{
			if (d_timer.isRunning() < 1)
			{
				//bad programming this will run on forever/until collision
			}
			else
			{
				print("Reset Damage Timer");
				d_timer.stop();
				thisEntity.SetInt("invin",0);
			}
		}


	if (input.GetKeyState(K_SPACE) == KS_DOWN)
		{
			thisEntity.SetFloat("HP",100);
			DrawFadingText(vector2(200,200),"spark X and Y " + sparkX + " " + sparkY + "\n " + strDirX + " " + strDirY,"Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);
			//thisEntity.SetUInt("touchingGround", 1);
			//body.ApplyLinearImpulse(vector2(0.0f, sparkY), vector2(thisEntity.GetPosition().x, thisEntity.GetPosition().y));
		}

		
	if (input.GetKeyState(K_UP) == KS_HIT)
		{

			//DrawFadingText(vector2(100,200),"test01","Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);
			//g_timer.showTimer(vector2(400, 100), textSize, 255, 203, 203, 228);
			//sparkY +=-1;
			
			//body.ApplyLinearImpulse(vector2(0.0f, sparkY), vector2(thisEntity.GetPosition().x, thisEntity.GetPosition().y));
			//thisEntity.SetUInt("touchingGround", 1);
			
			//DrawFadingText(vector2(100,200),"g_timer: " + g_timer.getElapsedTime(),"Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);
			//}
			//if (g_timer.getElapsedTime() <= 100)
			//{

				//}
				if (thisEntity.GetFloat("jumps") < thisEntity.GetFloat("maxJumps"))
				{
					g_timer.start();
					DrawFadingText(vector2(100,200),"start timer","Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);
					thisEntity.SetFloat("jumps", (thisEntity.GetFloat("jumps") + 1));
				}

			//}
			
				
			
		


			//body.ApplyLinearImpulse(normalize(vector2(0.0f, sparkY)), vector2(thisEntity.GetPosition().x, thisEntity.GetPosition().y));
		
			

			}

		if (input.GetKeyState(K_UP) == KS_DOWN)
			{


				/*string VelStr;
				vector2 VelVec;

				VelVec = body.GetLinearVelocity();
				VelStr = vector2ToString(VelVec);

				DrawFadingText(vector2(100,200),VelStr,"Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);*/
			
			

					if (g_timer.getElapsedTime() < 250)
					{

						//Velocity
						//body.ApplyLinearImpulse(normalize(vector2(0.0f, sparkY)), vector2(thisEntity.GetPosition().x, thisEntity.GetPosition().y));
						body.SetLinearVelocity(normalize(vector2(0.0f, sparkY)));
						thisEntity.SetFloat("forceY", -1);
					}

					else 
					{
						thisEntity.SetFloat("forceY", 0);
					}
			

		}

	if (input.GetKeyState(K_UP) == KS_RELEASE)
		{
			//DrawFadingText(vector2(100,200),"up","Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);
			thisEntity.SetFloat("forceY", 0);
		}

	if (input.GetKeyState(K_D) == KS_HIT)
		{
			addHP(thisEntity,-10);
			thisEntity.SetFloat("jumps",0);
		}
		
	if (input.GetKeyState(K_S) == KS_DOWN)
		{
				

			//VelVec = body.GetLinearVelocity();
			//VelStr = vector2ToString(VelVec);
			DrawFadingText(vector2(100,200),VelStr + " " + thisEntity.GetFloat("jumps") + " " + thisEntity.GetFloat("HP"),"Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);

		}
	if (KeyboardInput() != vector2(0,0))
		{
			thisEntity.SetUInt("lastKeyDir",find8way(KeyboardInput()));
			lastKeyDir2 = find8way(KeyboardInput());
			//bullet.SetUInt("moveDir",thisEntity.GetUInt("lastKeyDir"));
			print(thisEntity.GetUInt("lastKeyDir") + " " + lastKeyDir2);
		}
	if (input.GetKeyState(K_F) == KS_HIT)
		{
			
				ETHEntity @bullet = null;
				AddEntity("bullet.ent", thisEntity.GetPosition() + vector3(50, 0, 0), bullet);
				
				if (bullet !is null)
				{

					// the bullet direction will be the same as our character's last direction
					bulletMoveDir = bulletDir(lastKeyDir2);//extra//thisEntity.GetVector2("lastKeyDir")
					//bullet.SetFloat("speed", 250.0f);
				}
			


			//AddEntity("bullet.ent", vector3(thisEntity.GetPosition() + vector3(50,0,0)));
			//bullet.SetUInt("moveDir",thisEntity.GetUInt("lastKeyDir"));
			//bullet.AddToPositionXY(normalize(vector2(1,0)) * speed);
			//ETHEntity @bullet = SeekEntity("bullet.ent");
			//ETHPhysicsController @bullbody = bullet.GetPhysicsController();
			//bullbody.SetLinearVelocity(normalize(vector2(1.0f, 0.0f)));
		}
	if (input.GetKeyState(K_G) == KS_DOWN)
		{
			print(find8way(KeyboardInput()));
			//bullet.SetUInt("moveDir",(bullet.GetUInt("moveDir")+1));
		}
	if (input.GetKeyState(K_Q) == KS_HIT)
		{
			/*int xTime;
			xTime = 5;
			for (uint t=1; t<=xTime; t++)
			{
				for (uint t2=1; t2<=xTime; t2++)
				{
				AddEntity("bullet.ent", vector3(thisEntity.GetPosition() + vector3((50+t2),-(t*10),0)));
				//bullet.SetUInt("moveDir",thisEntity.GetUInt("lastKeyDir"));
				print(t + " " + t2);
				}

				//print(t + " " + t2);
			}*/
			vector2 bombPos(currentPos);
			vector2 bombBucket = GetBucket(bombPos);

			ETHEntityArray entities;

			// Copies into 'entities' a handle to each entity contained in the buckets around 'bombBucket'
			GetEntitiesAroundBucket(bombBucket, entities);

			for (uint t = 0; t < entities.Size(); t++)
			    print(entities[t].GetEntityName() + " is around the Spark!   " + entities[t].GetID());
			    ////////////////////////////////////////////////////////////////^^^^^^^^^^^^^^^^^^^^^ this shows their ID
			
				
	
		}

	//if (thisEntity.CheckCustomData("elapsedTime") == DT_NODATA)
		//{
			//thisEntity.SetUInt("elapsedTime", 0);

			//thisEntity.AddToUInt("elapsedTime", GetLastFrameElapsedTime());
		//}

	// do a certain operation each 300 millisecs
	//if (thisEntity.GetUInt("elapsedTime") > 300)
		//{

			//DrawFadingText(vector2(400,400),"Elaspe","Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);
			//thisEntity.SetUInt("elapsedTime", 0);
		//}
	if (thisEntity.GetFloat("HP") <= 0)
		{
			LoadScene("scenes/gameover.esc", "onGOCreate", "onGOUpdate");
		}


	sparkX = thisEntity.GetFloat("forceX");
	sparkY = thisEntity.GetFloat("forceY");
	thisEntity.AddToPositionXY(normalize(vector2(sparkX,sparkY)) * speed);
}



vector2 KeyboardInput()
{
	ETHInput @input = GetInputHandle();
	vector2 keydir(0, 0);

	if (input.KeyDown(K_LEFT))
		keydir.x +=-1;

	if (input.KeyDown(K_RIGHT))
		keydir.x += 1;

	if (input.KeyDown(K_UP))
		keydir.y +=-1;
		
	if (input.KeyDown(K_DOWN))
		keydir.y += 1;

	return keydir;
}

/////GAMEOVER/////

void ETHCallback_gameover(ETHEntity@ thisEntity)
{
	ETHInput @input = GetInputHandle();
	if (input.KeyDown(K_ENTER))
	{
		Exit();
	}
	if (input.KeyDown(K_R))
	{
		LoadScene("scenes/scene01.esc", "onCreate", "onUpdate");
	}
}

/////END GAMEOVER/////


/////Block collision/////

void ETHBeginContactCallback_mblock(
ETHEntity@ thisEntity,
ETHEntity@ other,
vector2 contactPointA,
vector2 contactPointB,
vector2 contactNormal)

{

if (other.GetEntityName() == "spark.ent")
	{
		print("Mr Sparkle hit block!");
		DrawFadingText(vector2(200,300),"Collide!","Verdana30_shadow.fnt",ARGB(120,25,46,255), 500);
		other.SetUInt("touchingGround", 1);
		other.SetFloat("jumps",0);


		if (VelVec.y >= 20)
		{
			
			//other.SetFloat("HP",(other.GetFloat("HP") - 10));
			addHP(other,-10);
			DrawFadingText(vector2(400,400),"10 DAMAGE","Verdana30_shadow.fnt",ARGB(120,25,255,255), 1000);

		}

		

	}

}


void ETHEndContactCallback_mblock(
	ETHEntity@ thisEntity,
	ETHEntity@ other,
	vector2 contactPointA,
	vector2 contactPointB,
	vector2 contactNormal)
{
	if (other.GetEntityName() == "spark.ent")
	{
		print("Our character is no longer stepping on the ground!");
		other.SetUInt("touchingGround", 0);

	}
}

/////End block collision/////

/////Fly collision/////

void ETHBeginContactCallback_flyEnm(
ETHEntity@ thisEntity,
ETHEntity@ other,
vector2 contactPointA,
vector2 contactPointB,
vector2 contactNormal)

{

if (other.GetEntityName() == "spark.ent")
	{
		if (other.GetInt("invin") < 1)
		{
			addHP(other,-5);
			print("Monster Damage");
			other.SetInt("invin",1);
			d_timer.start();
			print("Start Damage Timer");
			/*if (d_timer.getElapsedTime() <= 0)
			{
				print("Monster Damage");
				d_timer.start();
				addHP(other,-5);
			}

			if (d_timer.getElapsedTime() >= 2000)
			{
				print("Monster Reset");
				d_timer.reset();
			}*/
		}
		else
		{
			print("CAN'T TOUCH THIS");
		}
	}

}
/////End fly collision/////

/////BULLET BITCHES/////
void ETHBeginContactCallback_bullet(
ETHEntity@ thisEntity,
ETHEntity@ other,
vector2 contactPointA,
vector2 contactPointB,
vector2 contactNormal)

{
	if (other.GetEntityName() == "flyEnm.ent")
	{
		print("hit");
		//other.SetFloat("dead",1);
	}

}

void ETHEndContactCallback_bullet(
ETHEntity@ thisEntity,
ETHEntity@ other,
vector2 contactPointA,
vector2 contactPointB,
vector2 contactNormal)

{
	if (other.GetEntityName() == "flyEnm.ent")
	{
		print("ENDhit");
		other.SetFloat("dead",1);
	}
}

/////END BULLET BITCHES/////

void addHP(ETHEntity @thisEntity, const int value)
{
	int toAdd = thisEntity.GetFloat("HP");

	toAdd = (value+toAdd);

	thisEntity.SetFloat("HP",toAdd);

}
/*//TEST\\\
for (uint t=0; t<number; t++)
{

}
*///end TEST\\\\