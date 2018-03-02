using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Renderer))]
public class AutomaticRain : MonoBehaviour
{
    public Material material;

    [Space(20)]
    [Range(-1, 1)]
    public float precipitation = 0;

    [Space(20)]
    public float humidityAffectation;
    public float humidityDryAffectation;
    [Range(0, 1f)]
    public float maxHumidity;

    [Space(10)]
    public float waterAffectation;
    public float waterDryAffectation;
    [Range(0, 1f)]
    public float maxWater;

    [Space(10)]
    public float puddleAffectation;
    public float puddleDryAffectation;
    [Range(0, 1f)]
    public float maxPuddle;

    [Space(20)]
    [Range(0f, 10f)]
    public float maxDropStrength;

	void Update ()
    {
		if(material != null && material.shader.name == "EasyRain/Rain_v0.5")
        {
            if (precipitation > 0)
            {
                material.SetFloat("_DropStrength", Mathf.Lerp(0, maxDropStrength, precipitation));
                material.SetFloat("_HumidityLevel", Mathf.Clamp(material.GetFloat("_HumidityLevel") + (1.0f / humidityAffectation * precipitation * Time.deltaTime), material.GetFloat("_WaterLevel"), maxHumidity));
                if (material.GetFloat("_HumidityLevel") == maxHumidity) material.SetFloat("_WaterLevel", Mathf.Clamp(material.GetFloat("_WaterLevel") + (1.0f / waterAffectation * precipitation * Time.deltaTime), material.GetFloat("_PuddleLevel"), Mathf.Min(maxWater, material.GetFloat("_HumidityLevel"))));
                if (material.GetFloat("_WaterLevel") == maxWater) material.SetFloat("_PuddleLevel", Mathf.Clamp(material.GetFloat("_PuddleLevel") + (1.0f / puddleAffectation * precipitation * Time.deltaTime), 0, Mathf.Min(maxPuddle, material.GetFloat("_WaterLevel"))));
            }
            else
            {
                material.SetFloat("_DropStrength", 0.0f);
                material.SetFloat("_HumidityLevel", Mathf.Clamp(material.GetFloat("_HumidityLevel") + (1.0f / humidityDryAffectation * precipitation * Time.deltaTime), material.GetFloat("_WaterLevel"), maxHumidity));
                material.SetFloat("_WaterLevel", Mathf.Clamp(material.GetFloat("_WaterLevel") + (1.0f / waterDryAffectation * precipitation * Time.deltaTime), material.GetFloat("_PuddleLevel"), Mathf.Min(maxWater, material.GetFloat("_HumidityLevel"))));
                material.SetFloat("_PuddleLevel", Mathf.Clamp(material.GetFloat("_PuddleLevel") + (1.0f / puddleDryAffectation * precipitation * Time.deltaTime), 0, Mathf.Min(maxPuddle, material.GetFloat("_WaterLevel") - 0.2f)));
            }
        }
	}
}
