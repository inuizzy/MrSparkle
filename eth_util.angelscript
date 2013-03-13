/*--------------------------------------------------------------------------------------
 Ethanon Engine (C) Copyright 2008-2013 Andre Santee
 http://ethanonengine.com/

	Permission is hereby granted, free of charge, to any person obtaining a copy of this
	software and associated documentation files (the "Software"), to deal in the
	Software without restriction, including without limitation the rights to use, copy,
	modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
	and to permit persons to whom the Software is furnished to do so, subject to the
	following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
	INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
	PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
	CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
	OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--------------------------------------------------------------------------------------*/

/// Returns true if the point p is in screen
bool isPointInScreen(vector2 p)
{
	p -= GetCameraPos();
	if (p.x < 0 || p.y < 0 || p.x > GetScreenSize().x || p.y > GetScreenSize().y)
		return false;
	else
		return true;
}

/// Creates a string from a vector3
string vector3ToString(const vector3 v3)
{
	return "(" + v3.x + ", " + v3.y + ", " + v3.z + ")";
}

/// Creates a string from a vector2
string vector2ToString(const vector2 v2)
{
	return "(" + v2.x + ", " + v2.y + ")";
}

/// Converts a pixel format assignment to a stringInput
string formatToString(const PIXEL_FORMAT format)
{
	if (format == PF32BIT)
		return "32";
	if (format == PF16BIT)
		return "16";
	return "unknown";
}

/// Creates an array containing every entity within thisEntity's bucket and the buckets around it, including itself
void getSurroundingEntities(ETHEntity @thisEntity, ETHEntityArray @outEntities)
{
	const vector2 bucket(thisEntity.GetCurrentBucket());
	GetEntitiesFromBucket(bucket, outEntities);
	GetEntitiesFromBucket(bucket+vector2(1,0), outEntities);
	GetEntitiesFromBucket(bucket+vector2(1,1), outEntities);
	GetEntitiesFromBucket(bucket+vector2(0,1), outEntities);
	GetEntitiesFromBucket(bucket+vector2(-1,1), outEntities);
	GetEntitiesFromBucket(bucket+vector2(-1,0), outEntities);
	GetEntitiesFromBucket(bucket+vector2(-1,-1), outEntities);
	GetEntitiesFromBucket(bucket+vector2(0,-1), outEntities);
	GetEntitiesFromBucket(bucket+vector2(1,-1), outEntities);
}

/// Finds an entity named 'entityName' among all thisEntity's surrounding entities.
ETHEntity @findAmongNeighbourEntities(ETHEntity @thisEntity, const string entityName)
{
	ETHEntityArray entityArray;
	getSurroundingEntities(thisEntity, entityArray);
	uint size = entityArray.size();
	for (uint t=0; t<size; t++)
	{
		if (entityArray[t].GetEntityName() == entityName)
		{
			return @entityArray[t];
		}
	}
	return null;
}

/// Scans the screen for an entity named 'name' and returns a handle to it if found.
ETHEntity @findEntityInScreen(const string name)
{
	ETHEntityArray entities;
	GetVisibleEntities(entities);
	for (uint t=0; t<entities.size(); t++)
	{
		if (entities[t].GetEntityName() == name)
		{
			return entities[t];
		}
	}
	return null;
}

class Sphere
{
	Sphere(const vector3 _pos, const float _radius)
	{
		pos = _pos;
		radius = _radius;
	}
	vector3 pos;
	float radius;
}

bool intersectSpheres(const Sphere @a, const Sphere @b)
{
	if (distance(a.pos, b.pos) > a.radius+b.radius)
		return false;
	else
		return true;
}

class Circle
{
	Circle(const vector2 _pos, const float _radius)
	{
		pos = _pos;
		radius = _radius;
	}
	vector2 pos;
	float radius;
}

bool intersectCircles(const Circle @a, const Circle @b)
{
	if (distance(a.pos, b.pos) > a.radius+b.radius)
		return false;
	else
		return true;
}

/* 
 * stringInput class:
 * Places an input area on screen where the user can type texts
 */
class stringInput
{
	stringInput()
	{
		blinkTime = 300;
		lastBlink = 0;
		showingCarret = 1;
	}
	void PlaceInput(const string text, const vector2 pos, const string font, const uint color)
	{
		const uint time = GetTime();
		if ((time-lastBlink) > blinkTime)
		{
			showingCarret = showingCarret==0 ? 1 : 0;
			lastBlink = GetTime();
		}
	
		ETHInput @input = GetInputHandle();
		
		string lastInput = input.GetLastCharInput();
		if (lastInput != "")
		{
			ss += lastInput;
		}
		
		if (input.GetKeyState(K_BACKSPACE) == KS_HIT || input.GetKeyState(K_LEFT) == KS_HIT)
		{
			const uint len = ss.length();
			if (len > 0)
				ss.resize(len-1);
		}
		
		string outputString = text + ": " + ss;
		if (showingCarret==1)
			outputString += "|";
		DrawText(pos, outputString, font, color);
	}
	
	string GetString()
	{
		return ss;
	}
	
	private uint blinkTime;
	private uint lastBlink;
	private uint showingCarret;
	private string ss;
}

/* 
 * frameTimer class:
 * This object helps handling keyframe animation
 */
class frameTimer
{
	frameTimer()
	{
		m_currentFrame = m_currentFirst = m_currentLast = 0;
		m_lastTime = 0;
	}

	uint Get()
	{
		return m_currentFrame;
	}

	uint Set(const uint first, const uint last, const uint stride)
	{
		if (first != m_currentFirst || last != m_currentLast)
		{
			m_currentFrame = first;
			m_currentFirst = first;
			m_currentLast  = last;
			m_lastTime = GetTime();
			return m_currentFrame;
		}

		if (GetTime()-m_lastTime > stride)
		{
			m_currentFrame++;
			if (m_currentFrame > last)
				m_currentFrame = first;
			m_lastTime = GetTime();
		}

		return m_currentFrame;
	}

	private uint m_lastTime;
	private uint m_currentFirst;
	private uint m_currentLast;
	private uint m_currentFrame;
}

void shadowText(const vector2 pos, const string text, const string font, const float size,
				const uint8 a, const uint8 r, const uint8 g, const uint8 b)
{
	DrawText(pos+vector2(size*0.1f, size*0.1f), text, font, size, ARGB(a/2,0,0,0));
	DrawText(pos, text, font, size, ARGB(a,r,g,b));
}

string getTimeString(const uint time)
{
	const uint secs = (time/1000)%60;
	string seconds;
	if (secs < 10)
		seconds = "0"+secs;
	else
		seconds = ""+secs;
	return "" + (time/1000)/60 + ":" + seconds;
}

class Timer
{
	Timer()
	{
		startTime = 0;
	}
	
	void start()
	{
		startTime = GetTime();
	}
	
	uint getElapsedTime()
	{
		return GetTime()-startTime;
	}

	uint isRunning()
	{
		return startTime;
	}

	void reset()
	{
		//duplicate for organizing
		startTime = GetTime();
	}

	void stop()
	{
		startTime = 0;
	}

	
	void showTimer(const vector2 pos, const float size, const uint8 a,
				   const uint8 r, const uint8 g, const uint8 b)
	{
		const uint elapsed = getElapsedTime();
		string time = getTimeString(elapsed);
		shadowText(pos, time, "Verdana30_shadow.fnt", size, a, r, g, b);
	}
	
	private uint startTime;
}
/*
class Timer2 : GameController
{
	private uint m_time;
	private bool m_pausable;

	Timer()
	{
		m_pausable = true;
		reset();
	}

	Timer(bool pausable)
	{
		m_pausable = pausable;
		reset();
	}

	void update()
	{
		if (m_pausable)
			m_time += g_timeManager.getLastFrameElapsedTime();
		else
			m_time += GetLastFrameElapsedTime();
	}

	void reset()
	{
		m_time = 0;
	}

	void draw() {}

	uint getTime() const
	{
		return m_time;
	}
}*/
const uint DR = 0;
const uint R = 1;
const uint UR = 2;
const uint U = 3;
const uint UL = 4;
const uint L = 5;
const uint DL = 6;
const uint D = 7;

uint find8way(const vector2 v)
{
	const float angle = getAngle(v);
	const float angleInDegrees = radianToDegree(angle);

	uint dir;
	///// Example, x = low degree, y = high degree
	///// xy = direction
	/*if (angleInDegrees >= x && angleInDegrees < y)
	{
		dir = xy;
	}*/
	if (angleInDegrees >= 22.5 && angleInDegrees < 67.5)
	{
		dir = DR;
	}
	else if (angleInDegrees >= 67.5 && angleInDegrees < 112.5)
	{
		dir = R;
	}
	else if (angleInDegrees >= 112.5 && angleInDegrees < 157.5)
	{
		dir = UR;
	}
	else if (angleInDegrees >= 157.5 && angleInDegrees < 202.5)
	{
		dir = U;
	}
	else if (angleInDegrees >= 202.5 && angleInDegrees < 247.5)
	{
		dir = UL;
	}
	else if (angleInDegrees >= 247.5 && angleInDegrees < 292.5)
	{
		dir = L;
	}
	else if (angleInDegrees >= 292.5 && angleInDegrees < 337.5)
	{
		dir = DL;
	}
	else
	{
		dir = D;
	}
	return dir;

}

vector2 bulletDir(uint dirIN)
{
	vector2 dirOUT;
	//thisEntity.GetUInt("moveDir");
	if (dirIN == 0)
	{
		dirOUT = vector2(1,1);
	}
	else if (dirIN == 1)
	{
		dirOUT = vector2(1,0);
	}
	else if (dirIN == 2)
	{
		dirOUT = vector2(1,-1);
	}
	else if (dirIN == 3)
	{
		dirOUT = vector2(0,-1);
	}
	else if (dirIN == 4)
	{
		dirOUT = vector2(-1,-1);
	}
	else if (dirIN == 5)
	{
		dirOUT = vector2(-1,0);
	}
	else if (dirIN == 6)
	{
		dirOUT = vector2(-1,1);
	}
	else
	{
		dirOUT = vector2(0,1);
	}

	return dirOUT;
}