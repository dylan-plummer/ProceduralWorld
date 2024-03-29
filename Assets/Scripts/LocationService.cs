using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class LocationService : MonoBehaviour
{
	public Text locationText;
	private Vector3 startingPos;
	IEnumerator Start()
	{
		// First, check if user has location service enabled
		if (!Input.location.isEnabledByUser) {
			print("Unable to determine device location");
			yield break;
		}
		// Start service before querying location
		Input.location.Start();

		// Wait until service initializes
		int maxWait = 20;
		while (Input.location.status == LocationServiceStatus.Initializing && maxWait > 0)
		{
			print("Waiting");
			yield return new WaitForSeconds(1);
			maxWait--;
		}

		// Service didn't initialize in 20 seconds
		if (maxWait < 1)
		{
			print("Timed out");
			yield break;
		}

		// Connection has failed
		if (Input.location.status == LocationServiceStatus.Failed)
		{
			print("Unable to determine device location");
			yield break;
		}
		else
		{
			startingPos = new Vector3 (Input.location.lastData.latitude,
				Input.location.lastData.longitude,
				0);//Input.location.lastData.altitude);
			locationText.text = startingPos.ToString ();
			// Access granted and location value could be retrieved
			print("Location: " + startingPos.x + " " + startingPos.y + " " + startingPos.z);
			InvokeRepeating ("UpdateLocation", 5.0f, 30f);
			gameObject.transform.position = startingPos;
		}
	}

	public void UpdateLocation(){
		Vector3 currentPos = new Vector3 (Input.location.lastData.latitude,
			Input.location.lastData.longitude,
			Input.location.lastData.altitude);
	}
}