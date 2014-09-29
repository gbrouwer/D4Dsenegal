import java.io.*;
import java.nio.*;
import java.util.*;

public class Shape
{

	//Fields
	public List<Polygon> polygons;
	public List<Line> lines;
	public List<Point> points;
	public List<Attribute> attributes;
	public List<Header> headers;


	//------------------------------------------------------------------------------------
	public Shape()
		{

		polygons = new ArrayList<Polygon>();
		attributes = new ArrayList<Attribute>();
		headers = new ArrayList<Header>();
		lines = new ArrayList<Line>();
		points = new ArrayList<Point>();

		}

	//------------------------------------------------------------------------------------
	public void createColors()
		{

		
		
		}
}