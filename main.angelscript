/*
 Hello world!
*/

Timer g_timer;

#include "eth_util.angelscript"
#include "Collide.angelscript"
#include "force.angelscript"

void main()
{
	LoadScene("scenes/scene01.esc", "onCreate", "onUpdate");

	// Prefer setting window properties in the app.enml file
	// SetWindowProperties("Ethanon Engine", 1024, 768, true, true, PF32BIT);
}

void onUpdate()
{
	ETHEntity@ thisEntity = SeekEntity("spark.ent");
	vector2 currentPos = thisEntity.GetPositionXY();
	bool touchingGround = (thisEntity.GetUInt("touchingGround") != 0);

	DrawFadingText(vector2(100,0),"Test: " + vector2ToString(getCurrentForce(thisEntity)) + "\n " + vector2ToString(currentPos) + "\n" + touchingGround + "\n" + GetTime(),"Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);

}

void ETHCallback_spark(ETHEntity@ thisEntity)
{
	ETHInput @input = GetInputHandle();
	ETHPhysicsController @body = thisEntity.GetPhysicsController();

	SetCameraPos(thisEntity.GetPositionXY() - (GetScreenSize() / 2.0f));
	const float textSize = 25.0f;
	vector2 moveDirection(0,0);
	moveDirection = KeyboardInput();
	vector2 currentPos = thisEntity.GetPositionXY();
	float speed = UnitsPerSecond(500.0f);
	float sparkX;
	float sparkY;
	string strDirX;
	string strDirY;
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

	if (input.GetKeyState(K_SPACE) == KS_DOWN)
		{
			DrawFadingText(vector2(200,200),"spark X and Y " + sparkX + " " + sparkY + "\n " + strDirX + " " + strDirY,"Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);
			//thisEntity.SetUInt("touchingGround", 1);
			//body.ApplyLinearImpulse(vector2(0.0f, sparkY), vector2(thisEntity.GetPosition().x, thisEntity.GetPosition().y));
		}

		
	if (input.GetKeyState(K_UP) == KS_DOWN)
		{

			//DrawFadingText(vector2(100,200),"test01","Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);
			//g_timer.showTimer(vector2(400, 100), textSize, 255, 203, 203, 228);
			//sparkY +=-1;
			
			//body.ApplyLinearImpulse(vector2(0.0f, sparkY), vector2(thisEntity.GetPosition().x, thisEntity.GetPosition().y));
			//thisEntity.SetUInt("touchingGround", 1);
			DrawFadingText(vector2(100,200),"test02","Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);
				
			float time1 = GetTime();
			float time2;
			
			
			thisEntity.SetFloat("forceY", -1);
			body.ApplyLinearImpulse(normalize(vector2(0.0f, sparkY)), vector2(thisEntity.GetPosition().x, thisEntity.GetPosition().y));
		
			

		}
		if (input.GetKeyState(K_UP) == KS_UP)
		{
			//DrawFadingText(vector2(100,200),"up","Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);
			thisEntity.SetFloat("forceY", 0);
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

	//if (input.KeyDown(K_UP))
		//keydir.y +=-1;
		
	//if (input.KeyDown(K_DOWN))
		//keydir.y += 1;

	return keydir;
}

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
		print("Our character is no longer stepping on the ground!");
		other.SetUInt("touchingGround", 0);
}