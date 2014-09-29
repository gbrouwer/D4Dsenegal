import org.lwjgl.LWJGLException;
import org.lwjgl.opengl.Display;
import org.lwjgl.opengl.DisplayMode;
import org.newdawn.slick.opengl.Texture;
import org.newdawn.slick.opengl.TextureLoader;
import org.lwjgl.opengl.GL11;
import java.util.*;
import java.io.*;
import java.nio.*;
import org.lwjgl.input.Keyboard;
import org.lwjgl.input.Mouse;



public class Render 
	{

	//Globals
	public List<Integer> indices;
	public List<Attribute> attributes;
	public List<Header> headers;
	public List<Polygon> polygons;
	public List<Line> lines;
	public List<Point> points;
	public float xmean = 14.5108079f;
	public float ymean = -14.461200f;
	public float ratio = 100.0f;
	public int curtexture = 0;
	public List<Texture> textures;


	//Textures
	Texture texture;
	Texture texture0;
	Texture texture1;
	Texture texture2;
	Texture texture3;
	Texture texture4;
	Texture texture5;
	Texture texture6;
	Texture texture7;
	Texture texture8;
	Texture texture9;


	//------------------------------------------------------------------------------------
   	public static void initGL()
   		{
	
		GL11.glMatrixMode(GL11.GL_PROJECTION);
		GL11.glLoadIdentity();
		GL11.glOrtho(0, 800, 0, 600, 1, -1);
		GL11.glMatrixMode(GL11.GL_MODELVIEW);
	
		//Anti-alaising
		GL11.glEnable(GL11.GL_POINT_SMOOTH);
		GL11.glHint(GL11.GL_POINT_SMOOTH_HINT, GL11.GL_NICEST);
		//GL11.glEnable(GL11.GL_LINE_SMOOTH);
		//GL11.glHint(GL11.GL_LINE_SMOOTH_HINT, GL11.GL_NICEST);

		}


	//------------------------------------------------------------------------------------
	public void drawPolygons(List<Polygon> polygons, List<Header> headers)
		{

		//Get Color Code
		float maxval = 0;
		for (int i=0;i<headers.size();i++)	
			{
			Header header = headers.get(i);
			int value = header.indices.get(3);
			if (maxval < value)
				{
				maxval = value;
				}
			}

		//Draw Polygons
		for (int i=0;i<polygons.size();i++)	
			{
			Polygon polygon = polygons.get(i);
			Header header = headers.get(i);
			int value = header.indices.get(3);
			float c1 = (((float)value / maxval) * 0.6f) + 0.2f;
			GL11.glColor3f(c1*0.8f,c1,c1*0.8f);
			GL11.glBegin(GL11.GL_TRIANGLES);
			for (int j=0;j<polygon.triangles.size();j++)
				{
				float x1 = 400 + ((polygon.triangles.get(j).x1 + xmean) * ratio);
				float y1 = 300 + ((polygon.triangles.get(j).y1 + ymean) * ratio);
				float x2 = 400 + ((polygon.triangles.get(j).x2 + xmean) * ratio);
				float y2 = 300 + ((polygon.triangles.get(j).y2 + ymean) * ratio);
				float x3 = 400 + ((polygon.triangles.get(j).x3 + xmean) * ratio);
				float y3 = 300 + ((polygon.triangles.get(j).y3 + ymean) * ratio);
				GL11.glVertex2f(x1,y1);
				GL11.glVertex2f(x2,y2);
				GL11.glVertex2f(x3,y3);
				}
			GL11.glEnd();
			}	
		}


	//------------------------------------------------------------------------------------
	public void drawPolygons(List<Polygon> polygons)
		{

		//Draw Polygons
		for (int i=0;i<polygons.size();i++)	
			{
			GL11.glBegin(GL11.GL_TRIANGLES);
			Polygon polygon = polygons.get(i);
			for (int j=0;j<polygon.triangles.size();j++)
				{
				float x1 = 400 + ((polygon.triangles.get(j).x1 + xmean) * ratio);
				float y1 = 300 + ((polygon.triangles.get(j).y1 + ymean) * ratio);
				float x2 = 400 + ((polygon.triangles.get(j).x2 + xmean) * ratio);
				float y2 = 300 + ((polygon.triangles.get(j).y2 + ymean) * ratio);
				float x3 = 400 + ((polygon.triangles.get(j).x3 + xmean) * ratio);
				float y3 = 300 + ((polygon.triangles.get(j).y3 + ymean) * ratio);
				GL11.glVertex2f(x1,y1);
				GL11.glVertex2f(x2,y2);
				GL11.glVertex2f(x3,y3);
				}
			GL11.glEnd();
			}	
		}


	//------------------------------------------------------------------------------------
	public void drawLines(List<Line> lines)
		{

		//Draw Polygons
		for (int i=0;i<lines.size();i++)	
			{
			GL11.glBegin(GL11.GL_LINE_STRIP);
			Line line = lines.get(i);
			for (int j=0;j<line.segments.size();j++)
				{
				float x1 = 400 + ((line.segments.get(j).x1 + xmean) * ratio);
				float y1 = 300 + ((line.segments.get(j).y1 + ymean) * ratio);
				GL11.glVertex2f(x1,y1);
				}
			GL11.glEnd();
			}	
		}


	//------------------------------------------------------------------------------------
	public void drawPoints(List<Point> points)
		{

		//Draw Polygons
		for (int i=0;i<points.size();i++)	
			{
			GL11.glBegin(GL11.GL_POINTS);
			Point point = points.get(i);
			float x1 = 400 + ((point.x + xmean) * ratio);
			float y1 = 300 + ((point.y + ymean) * ratio);
			GL11.glVertex2f(x1,y1);
			GL11.glEnd();
			}	
		}


	//------------------------------------------------------------------------------------
	public void renderGL(List<Shape> shapes) 
		{

		float circlesize = 4f;
		GL11.glClear(GL11.GL_COLOR_BUFFER_BIT | GL11.GL_DEPTH_BUFFER_BIT);
 		GL11.glClearColor(1.0f,1.0f,1.0f,0.0f);
		GL11.glPushMatrix();


		//Texture Coordinates
	 	float width = 310;
	 	float height = 309;
	 	float xstart = 50;
	 	float ystart = 74.5f;


		//Texture
		GL11.glPixelStorei(GL11.GL_UNPACK_ALIGNMENT, 1);
 		GL11.glTexParameteri(GL11.GL_TEXTURE_2D, GL11.GL_TEXTURE_WRAP_S, GL11.GL_REPEAT);
   		GL11.glTexParameteri(GL11.GL_TEXTURE_2D, GL11.GL_TEXTURE_WRAP_T, GL11.GL_REPEAT);
   		GL11.glTexParameteri(GL11.GL_TEXTURE_2D, GL11.GL_TEXTURE_MAG_FILTER, GL11.GL_NEAREST);
   		GL11.glTexParameteri(GL11.GL_TEXTURE_2D, GL11.GL_TEXTURE_MIN_FILTER, GL11.GL_NEAREST);


   		//Draw Sattelite Texture
		GL11.glColor3f(1,1,1);
		GL11.glEnable(GL11.GL_TEXTURE_2D);
		texture = textures.get(curtexture);
		texture.bind();
		GL11.glBegin(GL11.GL_QUADS);
		GL11.glTexCoord2f(1, 0);
		GL11.glVertex2f(xstart+512f-(width/2f)+width, ystart+384f-(height/2f)+height);
		GL11.glTexCoord2f(0, 0);
		GL11.glVertex2f(xstart+512f-(width/2f)-width, ystart+384f-(height/2f)+height);
		GL11.glTexCoord2f(0, 1);
		GL11.glVertex2f(xstart+512f-(width/2f)-width, ystart+384f-(height/2f)-height);
		GL11.glTexCoord2f(1, 1);
		GL11.glVertex2f(xstart+512f-(width/2f)+width, ystart+384f-(height/2f)-height);
		GL11.glEnd();



		//Outlines
		GL11.glLineWidth(3);
		GL11.glColor3f(0.75f,0.75f,0.0f);
		lines = shapes.get(5).lines;
		headers = shapes.get(5).headers;
		drawLines(lines);


		//Admin0
		GL11.glColor3f(0,1,0);
		lines = shapes.get(9).lines;
		//drawLines(lines);


		//Areas
		//GL11.glColor3f(0,0,0);
		//polygons = shapes.get(4).polygons;
		//headers = shapes.get(4).headers;
		//GL11.glPolygonMode(GL11.GL_FRONT_AND_BACK,GL11.GL_LINE);
		//drawPolygons(polygons);
		//GL11.glPolygonMode(GL11.GL_FRONT_AND_BACK,GL11.GL_FILL);


		//Roads
		GL11.glLineWidth(1);
		GL11.glColor3f(0,0,0);
		lines = shapes.get(1).lines;
		drawLines(lines);


		//Rail
		GL11.glColor3f(0,1,1);
		lines = shapes.get(2).lines;
		drawLines(lines);


		//Powerplants
		GL11.glPointSize(4);
		GL11.glColor3f(1,1,0);
		points = shapes.get(3).points;
		drawPoints(points);


		//Cities
		GL11.glPointSize(10);
		GL11.glColor3f(0,0,0);
		points = shapes.get(10).points;
		drawPoints(points);


		//Water
		GL11.glColor3f(0,0,1);
		polygons = shapes.get(0).polygons;
		//drawPolygons(polygons);
	
		
		GL11.glPopMatrix();
		
		}


	//------------------------------------------------------------------------------------
	public void readBackground()
		{

		//Read Sattelite
		textures = new ArrayList<Texture>();
		try 
			{
			texture = TextureLoader.getTexture("PNG", new FileInputStream(new File("data/images/satellite.png")));
			textures.add(texture);
			texture = TextureLoader.getTexture("PNG", new FileInputStream(new File("data/images/terrain.png")));
			textures.add(texture);
			texture = TextureLoader.getTexture("PNG", new FileInputStream(new File("data/images/agroecological.png")));
			textures.add(texture);
			texture = TextureLoader.getTexture("PNG", new FileInputStream(new File("data/images/geological.png")));
			textures.add(texture);
			texture = TextureLoader.getTexture("PNG", new FileInputStream(new File("data/images/hydrography.png")));
			textures.add(texture);
			texture = TextureLoader.getTexture("PNG", new FileInputStream(new File("data/images/land_degreadation.png")));
			textures.add(texture);
			texture = TextureLoader.getTexture("GIF", new FileInputStream(new File("data/images/landcover_detailed.gif")));
			textures.add(texture);
			texture = TextureLoader.getTexture("PNG", new FileInputStream(new File("data/images/ethnicities.png")));
			textures.add(texture);
			texture = TextureLoader.getTexture("PNG", new FileInputStream(new File("data/images/landcover.png")));
			textures.add(texture);
			texture = TextureLoader.getTexture("PNG", new FileInputStream(new File("data/images/watererosion.png")));
			textures.add(texture);
			} 
		catch (FileNotFoundException e) 
			{
			e.printStackTrace();
			Display.destroy();
			System.exit(1);
			} 
		catch (IOException e) 
			{
			e.printStackTrace();
			Display.destroy();
			System.exit(1);
			}
		}


	//------------------------------------------------------------------------------------
	public void pollInput() 
		{
		

		//Get Mouse Position
		if (Mouse.isButtonDown(0)) 
			{
			int x = Mouse.getX();
			int y = Mouse.getY();
			System.out.println("MOUSE DOWN @ X: " + x + " Y: " + y);
			}


		//Change Texture
		while (Keyboard.next()) 
			{
			if (Keyboard.getEventKeyState()) 
				{
				if (Keyboard.getEventKey() == Keyboard.KEY_A) 
					{
					System.out.printf("Changing Texture\n");
					curtexture++;
					if (curtexture > 9)
						{
						curtexture = 0;	
						}
					}
				}
			}


		//Kill Screen
		if (Keyboard.isKeyDown(Keyboard.KEY_SPACE)) 
			{
			Display.destroy();
			}
 

 
		}


	//------------------------------------------------------------------------------------
	public void display(List<Shape> shapes)
	{

		//Init lists
		polygons = new ArrayList<Polygon>();
		lines = new ArrayList<Line>();
		points = new ArrayList<Point>();
		attributes = new ArrayList<Attribute>();
		headers = new ArrayList<Header>();
		indices = new ArrayList<Integer>();


		//Open Window
		try 
			{
			Display.setDisplayMode(new DisplayMode(1200, 900));
			//Display.setDisplayMode(displayMode);
			Display.setFullscreen(true);
			Display.create();
			} 
		catch (LWJGLException e) 
			{
			e.printStackTrace();
			System.exit(0);
			}
 		

 		//Init openGL
		initGL(); 


		//Read Background Sattelite Image
		readBackground();


		//Idle Function
		while (!Display.isCloseRequested()) 
			{
			renderGL(shapes);
			pollInput();
			Display.update();
			Display.sync(60);
			}
		Display.destroy();




	}



}

