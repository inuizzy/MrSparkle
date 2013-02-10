void setForceX(ETHEntity @thisEntity, const float f)
{
	thisEntity.SetFloat("forceX", f);
}

void setForceY(ETHEntity @thisEntity, const float f)
{
	thisEntity.SetFloat("forceY", f);
}

vector2 getCurrentForce(ETHEntity @thisEntity)
{
	const float x = thisEntity.GetFloat("forceX");
	const float y = thisEntity.GetFloat("forceY");
	return vector2(x,y);
}


/* shouldn't need
void move(ETHEntity @thisEntity)
{

	float speed = UnitsPerSecond(500.0f);
	// if it's down and touching the ground, remove force Y to avoid unnecessary movement
	//if (thisEntity.GetUInt("touchingGround") == 1 && thisEntity.GetFloat("forceY") > 0)
		//thisEntity.SetFloat("forceY", 0);
	
	vector2 v(thisEntity.GetFloat("forceX"), thisEntity.GetFloat("forceY"));
	const float fps = GetFPSRate() == 0 ? 60 : GetFPSRate();
	v = (v/fps);
	
	// do not let it be greater than the entity's size to avoid passing through objects
	const float size = min(thisEntity.GetSize().x, thisEntity.GetSize().y)*0.4f;
	if (getLength(v) >= size)
	{
		v = normalize(v)*size*0.9f;
	}

	thisEntity.AddToPositionXY(v * speed);
}

*/
vector2 getPlayerXYAxis(const uint player)
{
	vector2 r(0,0);
	ETHInput @input = GetInputHandle();
	
		if (input.KeyDown(K_LEFT))
			r.x=-1;
		if (input.KeyDown(K_RIGHT))
			r.x=1;
		if (input.KeyDown(K_UP))
			r.y=-1;
		if (input.KeyDown(K_DOWN))
			r.y=1;
	
	
	return r;
}

const uint RIGHT = 0;
const uint LEFT = 1;
const uint DOWN = 2;
const uint UP = 3;

string directionToString(const uint dir)
{
	switch (dir)
	{
	case LEFT:
		return "LEFT";
	case RIGHT:
		return "RIGHT";
	case UP:
		return "UP";
	case DOWN:
		return "DOWN";
	}
	return "";
}

uint getInputDirection(const uint player)
{
	vector2 xy = getPlayerXYAxis(player);
	if (xy.x > 0)
		return RIGHT;
	else if (xy.x < 0)
		return LEFT;
	return DOWN;
}

float getLength(const vector2 v)
{
	return sqrt(v.x*v.x + v.y*v.y);
}
