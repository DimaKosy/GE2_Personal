# Project Title

Name: Dmytro Kosynskyy

Student Number: C21376161

Class Group: TU858

# Description
Simulation of critters using procedural kinematics simulation

## Video:

[![YouTube](http://img.youtube.com/vi/J2kHSSFA4NU/0.jpg)](https://www.youtube.com/watch?v=J2kHSSFA4NU)

## Screenshots

![An image](C1.PNG)

![An image](C2.PNG)

![An image](C3.PNG)

# Instructions

This is a showcase of inverse kinematics and how it can be used to create reptiles, insects and other animals
There is a tilemap which can be used to edit the simulation space and a couple of preplaced "Animals"

# How it works



# List of classes/assets

| Class/asset | Source |
|-----------|-----------|
| head.gd | Self written |
| Player.gd | Self written |
| snake_body.gd | Self written |
| snake_head.gd | Self written |

| Hana Caraka tileset | gotten from [hyperlink](https://otterisk.itch.io/hana-caraka-farming-foraging) |


# References
* Procedural Snake [hyperlink](https://www.youtube.com/watch?v=T73lvhhw_rA)
* Kinematics https://www.youtube.com/watch?v=hbgDqyy8bIw
* Kinematics https://www.youtube.com/watch?v=RTc6i-7N3ms


# Leg Kinematic solver

```gd
func leg_joint_update(source:Vector2, destination:Vector2, leg_index:int, leg_joint:Array, side:int):
	leg_joint[leg_index].set_point_position(0, source)
	
	# move the end point 
	var last_index = leg_joint[leg_index].get_point_count() - 1
	var current_end = leg_joint[leg_index].get_point_position(last_index)
	var new_end = current_end + (destination - current_end) * inter_rate
	leg_joint[leg_index].set_point_position(last_index, new_end)
	
	# move the points back
	for i in range(last_index - 1, 0, -1):
		var next_pos = leg_joint[leg_index].get_point_position(i + 1)
		var dir = (leg_joint[leg_index].get_point_position(i) - next_pos).normalized()
		leg_joint[leg_index].set_point_position(i, next_pos + dir * segment_length)
	
	for i in range(1, leg_joint[leg_index].get_point_count()):
		var prev = leg_joint[leg_index].get_point_position(i - 1)
		var dir = (leg_joint[leg_index].get_point_position(i) - prev).normalized()
		leg_joint[leg_index].set_point_position(i, prev + dir * segment_length)
	pass
```


# From here on, are examples of how to different things in Markdown. You can delete.  

## This is how to markdown text:

This is *emphasis*

This is a bulleted list

- Item
- Item

This is a numbered list

1. Item
1. Item

This is a [hyperlink](http://bryanduggan.org)

# Headings
## Headings
#### Headings
##### Headings

This is code:

```Java
public void render()
{
	ui.noFill();
	ui.stroke(255);
	ui.rect(x, y, width, height);
	ui.textAlign(PApplet.CENTER, PApplet.CENTER);
	ui.text(text, x + width * 0.5f, y + height * 0.5f);
}
```

So is this without specifying the language:

```
public void render()
{
	ui.noFill();
	ui.stroke(255);
	ui.rect(x, y, width, height);
	ui.textAlign(PApplet.CENTER, PApplet.CENTER);
	ui.text(text, x + width * 0.5f, y + height * 0.5f);
}
```

This is an image using a relative URL:

![An image](images/p8.png)

This is an image using an absolute URL:

![A different image](https://bryanduggandotorg.files.wordpress.com/2019/02/infinite-forms-00045.png?w=595&h=&zoom=2)

This is a youtube video:

[![YouTube](http://img.youtube.com/vi/J2kHSSFA4NU/0.jpg)](https://www.youtube.com/watch?v=J2kHSSFA4NU)

This is a table:

| Heading 1 | Heading 2 |
|-----------|-----------|
|Some stuff | Some more stuff in this column |
|Some stuff | Some more stuff in this column |
|Some stuff | Some more stuff in this column |
|Some stuff | Some more stuff in this column |

