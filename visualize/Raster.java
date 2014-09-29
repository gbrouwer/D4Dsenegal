import java.io.*;
import java.nio.*;
import java.util.*;

public class Graph{

	//Fields
	public int nNodes;
	public int nEdges;
	public List<Edge> edges;
	public List<Node> nodes;


	//------------------------------------------------------------------------------------
	public void read(String filename)
		{

		System.out.printf("Reading: %s\n",filename);

		try{
		
			//Open
			FileInputStream file = new FileInputStream(filename);
			DataInputStream in = new DataInputStream(file);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));

			//Header  
			nNodes = Integer.parseInt(br.readLine());
			nEdges = Integer.parseInt(br.readLine());
			
			//Create Nodes List
			nodes = new ArrayList<Node>();
			edges = new ArrayList<Edge>();
			
			//Read Nodes
			for (int i=0;i<nNodes;i++)
				{
				//Create Node
				Node node = new Node();				
				node.neighbors = new ArrayList<Edge>();
				
				//Read Value
				String vertex = br.readLine();
				StringTokenizer tokenizer = new StringTokenizer(vertex,"	");
				node.x = Float.parseFloat(tokenizer.nextToken());
				node.y = Float.parseFloat(tokenizer.nextToken());
				node.visited = false;
				nodes.add(node);
				}			
			
			//Read Edges
			for (int i=0;i<nEdges;i++)
				{
				//Create Edge
				Edge edge = new Edge();
				
				//Read Value
				String vertex = br.readLine();
				StringTokenizer tokenizer = new StringTokenizer(vertex,"	");
				edge.from = Integer.parseInt(tokenizer.nextToken());
				edge.to = Integer.parseInt(tokenizer.nextToken());
				edge.weight = Float.parseFloat(tokenizer.nextToken());
				edge.visited = false;

				//Add this edge to the from node in neighbor list
				nodes.get(edge.from).neighbors.add(edge);
				
				//And also add it to the edges (handy for some algorithms)
				edges.add(edge);
				}
			
			//Close
			in.close();
			
			}
		catch (Exception e)
			{
			
			//Catch exception if any
			System.err.println("Error: " + e.getMessage());
			
			}
		

		}


	//------------------------------------------------------------------------------------
	public static void main(String args[])
		{
		
		//Test Client for reading Graph
		//Graph graph = new Graph();
		//graph.read("graph.dat");
		
		}

}