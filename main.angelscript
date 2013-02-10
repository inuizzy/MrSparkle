/*
 Hello world!
*/

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

	DrawFadingText(vector2(100,0),"Test: " + vector2ToString(getCurrentForce(thisEntity)) + "\n " + vector2ToString(currentPos) + "\n" + touchingGround,"Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);

}

void ETHCallback_spark(ETHEntity@ thisEntity)
{
	ETHInput @input = GetInputHandle();

	SetCameraPos(thisEntity.GetPositionXY() - (GetScreenSize() / 2.0f));
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
	thisEntity.SetFloat("forceY", moveDirection.y);

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
	if (CollideStatic(thisEntity))
		{
			thisEntity.SetUInt("touchingGround", 1);
		}


	if (input.GetKeyState(K_SPACE) == KS_DOWN)
		{
			DrawFadingText(vector2(200,200),"spark X and Y " + sparkX + " " + sparkY + "\n " + strDirX + " " + strDirY,"Verdana30_shadow.fnt",ARGB(120,25,46,255), 100);
			thisEntity.SetUInt("touchingGround", 1);
		}


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