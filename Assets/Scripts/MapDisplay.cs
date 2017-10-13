using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapDisplay : MonoBehaviour {
	public MeshFilter meshFilter;
	public MeshRenderer meshRender;
	public Renderer textureRender;

	public void DrawTexture(Texture2D texture){

		textureRender.sharedMaterial.mainTexture = texture;
		textureRender.transform.localScale = new Vector3 (texture.width, 1, texture.height);

	}

	public void DrawMesh(MeshData meshData, Texture2D texture){
		meshFilter.sharedMesh = meshData.CreateMesh ();
		meshRender.sharedMaterial.mainTexture = texture;
	}
}
