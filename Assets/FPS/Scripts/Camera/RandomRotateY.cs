using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomRotateY : MonoBehaviour
{

	public float minValue = 15.0f;
	public float maxValue = 75.0f;
	public float maxSpeed = 0.4f;
	public float speedNoise = 0.1f;
	private float target;
	// Start is called before the first frame update
	void Start()
	{
		target = Random.Range(minValue, maxValue);
		LoopRandomTarget();
	}

	// Update is called once per frame
	void Update()
	{
		Vector3 angles = transform.eulerAngles;
		var change = Mathf.Clamp(target - angles.y, -maxSpeed + Random.Range(-speedNoise, speedNoise), maxSpeed + Random.Range(-speedNoise, speedNoise));
		angles.y += change;
		transform.eulerAngles = angles;

	}

	void LoopRandomTarget()
	{
		SetRandomTarget();
		Invoke("LoopRandomTarget", Random.Range(2, 4));
	}

	void SetRandomTarget()
	{
		target = Random.Range(minValue, maxValue);
	}
}
