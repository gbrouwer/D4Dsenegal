import java.io.*;
import java.nio.*;
import java.util.*;


public class Visualize 
	{


	//Global
	public List<String> files;
	public List<String> filestrings;
	public List<Attribute> attributes;
	public List<Header> headers;
	public static List<Shape> shapes;
	public List<Polygon> polygons;


	//------------------------------------------------------------------------------------
	public void ReadFiles(String category, String shapetype, String filetype)
		{
	

		//New File List
		files = new ArrayList<String>();

	
		//Get File Object
		String cwd = System.getProperty("user.dir");
		File folder = new File(cwd + "/data/" + shapetype + "/" + category + "/" + filetype);
		File[] listOfFiles = folder.listFiles();

	
		//Loop Through Files
    	for (int i = 0; i < listOfFiles.length; i++)
    		{
    		String filename = '/' + listOfFiles[i].getName();
      		if (listOfFiles[i].isFile() & filename.contains(filetype)) 
      			{
      			files.add(folder + filename);
				} 
		    }

		}


	//------------------------------------------------------------------------------------
	public void ReadFromFile(String filename)
		{

		//Read Strings From File
		String fileline;
		try
			{

			//Open
			FileInputStream file = new FileInputStream(filename);
			DataInputStream in = new DataInputStream(file);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));

			//Read until EOF
			filestrings = new ArrayList<String>();
			while ((fileline = br.readLine()) != null) 
				{
				filestrings.add(fileline);				
				}

			}
		catch (Exception e)
			{
			System.err.println("Error: " + e.getMessage());
			}		

		}


	//------------------------------------------------------------------------------------
   	public void ReadAttributes(String category)
   		{


   		//Create Attributes object
   		attributes = new ArrayList<Attribute>();


		 //String Tokenizer
		 StringTokenizer tokenizer;



   		//Read the Attribute Files
   		ReadFiles(category,"shapes","attribute");



   		//Loop through Attribute files
   		for (int i=0;i<files.size();i++)
   			{

   			//Create an Attribute Object
   			Attribute attribute = new Attribute();

			   //Read File
   			ReadFromFile(files.get(i));

   			//Extract Field name and store
   			for (int j=0;j<filestrings.size();j++)
   				{
				tokenizer = new StringTokenizer(filestrings.get(j),",");
				int value = Integer.parseInt(tokenizer.nextToken());
				attribute.indices.add(value);
				attribute.names.add(tokenizer.nextToken());

   				}

   			//Store
			   attributes.add(attribute);

   			}

   		}


	//------------------------------------------------------------------------------------
   	public void ReadHeaders(String category)
   		{


   		//Create Attributes object
   		headers = new ArrayList<Header>();


		   //String Tokenizer
		   StringTokenizer tokenizer;


   		//Read the Attribute Files
   		ReadFiles(category,"shapes","header");


   		//Loop through Attribute files
   		for (int i=0;i<files.size();i++)
   			{

   			//Create a Header Object
   			Header header = new Header();

			   //Read File
   			ReadFromFile(files.get(i));

   			//Extract Field name and store
   			for (int j=0;j<filestrings.size();j++)
   				{
				   int value = Integer.parseInt(filestrings.get(j));
   				header.indices.add(value);
   				}

   			//Store
			   headers.add(header);

   			} 

   		}


	//------------------------------------------------------------------------------------
   	public Shape ReadLines(String category)
   		{

   		//Verbose
   		System.out.printf("[INFO] Reading Line category: %s\n",category);


   		//Create Shape Object
   		Shape shape = new Shape();


         //String Tokenizer
         StringTokenizer tokenizer;


   		//Read Attributes
   		ReadAttributes(category);
   		shape.attributes = attributes;


   		//Read Headers
   		ReadHeaders(category);
   		shape.headers = headers;


   		//Read Polygons
   		ReadFiles(category,"shapes","lines");


   		//Loop through Polygon files
   		for (int i=0;i<files.size();i++)
   			{

   			//Create a Header Object
   			Line line = new Line();

			//Read File
   			ReadFromFile(files.get(i));

   			//Extract Triangles
   			for (int j=1;j<filestrings.size();j++)
   				{
   				Segment segment = new Segment();
				tokenizer = new StringTokenizer(filestrings.get(j),",");
				int index = (int)Float.parseFloat(tokenizer.nextToken());
				segment.x1 = Float.parseFloat(tokenizer.nextToken());
				segment.y1 = Float.parseFloat(tokenizer.nextToken());
				line.segments.add(segment);
				line.indices.add(index);
   				}

   			//Store Polygon
   			shape.lines.add(line);

   			} 


   		//Return
   	 	return shape;


   		}


	//------------------------------------------------------------------------------------
   	public Shape ReadPolygons(String category)
   		{

   		//Verbose
   		System.out.printf("[INFO] Reading Polygon category: %s\n",category);


   		//Create Shape Object
   		Shape shape = new Shape();


         //String Tokenizer
         StringTokenizer tokenizer;


   		//Read Attributes
   		ReadAttributes(category);
   		shape.attributes = attributes;


   		//Read Headers
   		ReadHeaders(category);
   		shape.headers = headers;


   		//Read Lines
   		ReadFiles(category,"shapes","polygon");


   		//Loop through Polygon files
   		for (int i=0;i<files.size();i++)
   			{

   			//Create a Header Object
   			Polygon polygon = new Polygon();

            //Read File
   			ReadFromFile(files.get(i));

   			//Extract Triangles
   			for (int j=1;j<filestrings.size();j++)
   				{
               Triangle triangle = new Triangle();
               tokenizer = new StringTokenizer(filestrings.get(j),",");
               int index = Integer.parseInt(tokenizer.nextToken());
               triangle.x1 = Float.parseFloat(tokenizer.nextToken());
               triangle.y1 = Float.parseFloat(tokenizer.nextToken());
               triangle.x2 = Float.parseFloat(tokenizer.nextToken());
               triangle.y2 = Float.parseFloat(tokenizer.nextToken());
               triangle.x3 = Float.parseFloat(tokenizer.nextToken());
               triangle.y3 = Float.parseFloat(tokenizer.nextToken());
               polygon.triangles.add(triangle);
               polygon.indices.add(index);
               }

   			//Store Polygon
   			shape.polygons.add(polygon);

   			} 

   		//Return
   	 	return shape;
   	 	}


	

	//------------------------------------------------------------------------------------
   	public Shape ReadPoints(String category)
   		{

   		//Verbose
   		System.out.printf("[INFO] Reading point category: %s\n",category);


   		//Create Shape Object
   		Shape shape = new Shape();


         //String Tokenizer
         StringTokenizer tokenizer;


   		//Read Attributes
   		ReadAttributes(category);
   		shape.attributes = attributes;


   		//Read Headers
   		ReadHeaders(category);
   		shape.headers = headers;


   		//Read Polygons
   		ReadFiles(category,"shapes","points");


   		//Loop through Polygon files
   		for (int i=0;i<files.size();i++)
   			{

   			//Create a Header Object
   			Point point = new Point();

			   //Read File
   			ReadFromFile(files.get(i));

   			//Extract Triangles
   			for (int j=1;j<filestrings.size();j++)
               {
				   tokenizer = new StringTokenizer(filestrings.get(j),",");
               int index = (int)Float.parseFloat(tokenizer.nextToken());
               point.x = Float.parseFloat(tokenizer.nextToken());
               point.y = Float.parseFloat(tokenizer.nextToken());

               }

   			//Store Polygon
   			shape.points.add(point);
		
   			} 

   		//Return
   	 	return shape;


   		}



	//------------------------------------------------------------------------------------
   	public void ReadShapes()
   		{

   		//Create Shapes Object
   		shapes = new ArrayList<Shape>();
   		

   		//Read Water Polygons
   		Shape water = new Shape();
         water = ReadPolygons("water");
   		shapes.add(water);


   		//Read Roads Lines
   		Shape roads = new Shape();
   		roads = ReadLines("roads");
   		shapes.add(roads);


   		//Read Roads Lines
   		Shape rails = new Shape();
   		rails = ReadLines("rails");
   		shapes.add(rails);


   		//Read Powerplant Points
   		Shape powerplants = new Shape();
   		powerplants = ReadPoints("powerplants");
   		shapes.add(powerplants);


   		//Read Area Polygons
   		Shape areas = new Shape();
   		areas = ReadPolygons("areas");
   		areas.createColors();
   		shapes.add(areas);


         //Read Outline Area Polygons
         Shape outline = new Shape();
         outline = ReadLines("outline");
         outline.createColors();
         shapes.add(outline);


         //Read Outline Area Polygons
         Shape admin0 = new Shape();
         admin0 = ReadLines("admin0");
         admin0.createColors();
         shapes.add(admin0);


         //Read Outline Area Polygons
         Shape admin1 = new Shape();
         admin1 = ReadLines("admin1");
         admin1.createColors();
         shapes.add(admin1);


         //Read Outline Area Polygons
         Shape admin2 = new Shape();
         admin2 = ReadLines("admin2");
         admin2.createColors();
         shapes.add(admin2);


         //Read Outline Area Polygons
         Shape admin3 = new Shape();
         admin3 = ReadLines("admin3");
         admin3.createColors();
         shapes.add(admin3);


         //Read Cities Points
         Shape cities = new Shape();
         cities = ReadPoints("cities");
         shapes.add(cities);



   		}


	//------------------------------------------------------------------------------------
	public static void main(String args[])
		{

		//Create Instance
		Visualize map = new Visualize();


		//Read Shapes
		map.ReadShapes();


		//Render
		Render screen = new Render();
		screen.display(shapes);


		}   		

	}