import java.io.*;
import java.nio.*;
import java.util.*;

public class Polygon
{

	//Fields
	public List<Triangle> triangles;
	public List<Integer> indices;


	//------------------------------------------------------------------------------------
	public Polygon()
		{

		triangles = new ArrayList<Triangle>();
		indices = new ArrayList<Integer>();

		}

}