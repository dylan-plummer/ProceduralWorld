using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TouchCamera : MonoBehaviour {
	public float rotateSpeed;
	public float zoomSpeed;
	public Camera camera;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void LateUpdate () {
		float pinchAmount = 0;
		Vector3 rotationDeg = Vector3.zero;
		DetectTouchMovement.Calculate();
		if (Mathf.Abs(DetectTouchMovement.pinchDistanceDelta) > 0) { // zoom
			pinchAmount = DetectTouchMovement.pinchDistanceDelta;
		}

		if (Mathf.Abs(DetectTouchMovement.turnAngleDelta) > 0) { // rotate
			rotationDeg.y = DetectTouchMovement.turnAngleDelta;
		}


		// not so sure those will work:
		transform.Rotate(rotationDeg * rotateSpeed,Space.World);
		if ((camera.transform.position.y > transform.position.y + 25) || (pinchAmount < 0 )) {
			if (camera.transform.position.y < 250 || pinchAmount > 0) {
				camera.transform.position = Vector3.MoveTowards (camera.transform.position, transform.position, pinchAmount * zoomSpeed);
			}
		}
	}
}
