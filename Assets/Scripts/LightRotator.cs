using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightRotator : MonoBehaviour {

	// Use this for initialization
	void Start () {
		//TODO initialize to time of day
	}
	
	// Update is called once per frame
	void Update () {
		//gameObject.transform.Rotate (new Vector3 (0, 0.03f, 0));
		gameObject.transform.RotateAround (Vector3.zero, Vector3.left, 0.1f);
	}
}
