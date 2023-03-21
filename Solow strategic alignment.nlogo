; Define global variables
globals [
  capital labor technology savings-rate depreciation-rate population-growth-rate alpha
  previous-output previous-technology human-capital rho market-competition-factor
  resource-demand resource-constraints
  reciprocity ; Social Exchange Theory
  social-ties ; Social Network Theory
  cultural-fit ; Organizational Culture Theory
  resource-based-view-factor

]

; Define agent breed and attributes
breed [org-members org-member]
org-members-own [
  level alignment productivity task-completion skill-level
  trust shared-goals conflict-resolution communication-channel collaboration-tool
  data-quality application-usage training learning-rate tangible-resources  intangible-resources  dynamic-capabilities  strategic-management
  attitude subjective-norms perceived-behavioral-control
  intrinsic-motivation extrinsic-motivation
  motivators hygiene-factors job-satisfaction
]

; Setup procedure to initialize the model
to setup
  clear-all
  reset-ticks
  ; Initialize global variables
  ;set num-levels 5
  set capital 100
  set labor 500
  set technology 1
  set alpha 0.3
  set savings-rate 0.25
  set depreciation-rate 0.1
  set population-growth-rate 0.02
  set resource-based-view-factor random-float 1
  set human-capital 1
  set market-competition-factor random-float 1
  set rho random-float 1

  ; Initialize resource-demand and resource-constraints
  set resource-demand 0
  set resource-constraints 1

  ; Initialize previous output and technology variables
  set previous-output 0
  set previous-technology 1

  ; Create org-member agents
  create-org-members labor [
    ; Assign random attributes to each org-member
    set level random num-levels
    set alignment 1
    set productivity 1
    set task-completion 0
    set skill-level random-float 1

    ; Initialize new attributes with random values between 0 and 1
    set trust random-float 0.1
    set shared-goals random-float 1
    set conflict-resolution random-float 1
    set communication-channel random-float 1
    set collaboration-tool random-float 1
    set data-quality random-float 1
    set application-usage random-float 1
    set training random-float 1
    set reciprocity random-float 1 ; Social Exchange Theory
    set social-ties random-float 1 ; Social Network Theory
    set cultural-fit random-float 1 ; Organizational Culture Theory

    ; Add learning rate attribute with a random value between 0 and 1
    set learning-rate random-float 1
    set tangible-resources random-float 1
    set intangible-resources random-float 1
    set dynamic-capabilities random-float 1
    set strategic-management random-float 1
    set attitude random-float 1
    set subjective-norms random-float 1
    set perceived-behavioral-control random-float 1
    set intrinsic-motivation random-float 1
    set extrinsic-motivation random-float 1
    set motivators random-float 1
    set hygiene-factors random-float 1
    set job-satisfaction random-float 1

    ; Place org-member on an empty patch
    move-to one-of patches with [not any? other turtles-here]
  ]

end

to go
  ; Update alignment for each organization member based on the network type and its neighbors
  ask org-members [
    ; Initialize a variable to store the neighboring nodes
    let nodes nobody
    ; Set the neighboring nodes based on the network type
    if network-type = "hierarchical" [
      set nodes org-members with [level = [level] of myself - 1]
    ]
    if network-type = "flat" [
      set nodes org-members with [level = [level] of myself]
    ]
    if network-type = "matrix" [
      set nodes org-members with [level != [level] of myself]
    ]
    if network-type = "holacracy" [
      set nodes other org-members
    ]
    if network-type = "functional" [
      set nodes org-members with [level = [level] of myself]
    ]
    if network-type = "divisional" [
      set nodes org-members with [level = [level] of myself - 1]
    ]
    if network-type = "hybrid" [
      let functional-nodes org-members with [level = [level] of myself]
      let divisional-nodes org-members with [level = [level] of myself - 1]
      set nodes (turtle-set functional-nodes divisional-nodes)
    ]
    ; Update the alignment based on interactions with the neighboring nodes
    update-alignment-based-on-interaction nodes
  ]

  ; Update data quality, application usage, training, and skill level for each organization member
  ask org-members [
    set data-quality data-quality + ((alignment - 1) * 0.01)
    set application-usage application-usage + ((alignment - 1) * 0.01)
    set training max list 0 (training + ((alignment - 1) * 0.01)) ; Using max 0 as training seems to take negative values sometimes
    set skill-level skill-level + (learning-rate * training * resource-constraints)
  ]

  ; Update productivity for each organization member based on their skill level
  ask org-members [set productivity productivity + (0.01 * skill-level)]

  ; Calculate resource demand and resource constraints
  set resource-demand sum [skill-level] of org-members
  set resource-constraints 1 / (1 + (resource-demand / 100))

  ; Update task completion for each organization member
  ask org-members [set task-completion task-completion + (productivity * alignment * business-it-alignment)]

  ; Calculate total task completion and human capital
  let total-task-completion sum [task-completion] of org-members
  let total-human-capital sum [skill-level] of org-members ; Calculate the total human capital
  set human-capital total-human-capital / count org-members ; Calculate the average human capital


  ; Calculate production based on the Cobb-Douglas production function
  let production (capital ^ (alpha * rho)) * ((total-task-completion * technology * human-capital * market-competition-factor * resource-based-view-factor) ^ ((1 - alpha) * rho))

  ; Update capital and technology
  set capital (savings-rate * production) + (1 - depreciation-rate) * capital
  set labor count org-members
  set technology technology * (1 + technology-growth-rate)

  ; Calculate and plot the overall economic growth rate if there is previous output and technology data
  if previous-output > 0 and previous-technology > 0 [
    let overall_economic_growth_rate ((production / (previous-output * previous-technology)) - 1) * 100
    set-current-plot "Overall Economic Growth Rate"
    set-current-plot-pen "Growth Rate"
    plot overall_economic_growth_rate ; Plot the overall economic growth rate
;    set-current-plot-pen "Technology"
;    plot technology
    set-current-plot-pen "Production"
    plot production

  ]

  ; Update the previous output and technology values for the next tick
  set previous-output production ; Update the previous output for the next tick
  set previous-technology technology ; Update the previous technology for the next tick

  ; Advance the simulation by one tick
  tick
end


; Update agent alignment based on the interaction with chosen nodes
to update-alignment-based-on-interaction [nodes]
  ; Check if there are any nodes to interact with
  if any? nodes [
    ; Choose one node randomly from the given nodes
    let chosen-node one-of nodes
    ; Calculate interaction factor based on the average of trust, shared-goals, conflict-resolution,
    ; communication-channel, and collaboration-tool attributes of the agent and its chosen node
    let interaction-factor (
      (trust + [trust] of chosen-node) / 2
      + (shared-goals + [shared-goals] of chosen-node) / 2
      + (conflict-resolution + [conflict-resolution] of chosen-node) / 2
      + (communication-channel + [communication-channel] of chosen-node) / 2
      + (collaboration-tool + [collaboration-tool] of chosen-node) / 2
      + (reciprocity + [reciprocity] of chosen-node) / 2
      + (social-ties + [social-ties] of chosen-node) / 2
      + (cultural-fit + [cultural-fit] of chosen-node) / 2
    ) / 8
    ; Update agent's alignment using the interaction factor
    set alignment alignment * [alignment] of chosen-node * interaction-factor

    ; Update tangible resources, intangible resources, dynamic capabilities, and strategic management based on interactions
    update-tangible-resources chosen-node
    update-intangible-resources chosen-node
    update-dynamic-capabilities chosen-node
    update-strategic-management chosen-node
  ]
end

; New procedure to update resource constraints
to update-resource-constraints
  ; Calculate resource demand based on the sum of skill levels of all org-members
  set resource-demand sum [skill-level] of org-members

  ; Negative feedback loop: Higher resource demand leads to resource constraints
  set resource-constraints 1 / (1 + (resource-demand / 100))
end
to update-social-ties [chosen-node]
  let current-ties social-ties
  let other-ties [social-ties] of chosen-node
  set social-ties (current-ties + other-ties) / 2
end

to update-reciprocity [chosen-node]
  let current-reciprocity reciprocity
  let other-reciprocity [reciprocity] of chosen-node
  set reciprocity (current-reciprocity + other-reciprocity) / 2
end

to update-cultural-fit [chosen-node]
  let current-fit cultural-fit
  let other-fit [cultural-fit] of chosen-node
  set cultural-fit (current-fit + other-fit) / 2
end

to update-tangible-resources [chosen-node]
  let current-resources tangible-resources
  let other-resources [tangible-resources] of chosen-node
  set tangible-resources (current-resources + other-resources) / 2
end

to update-intangible-resources [chosen-node]
  let current-resources intangible-resources
  let other-resources [intangible-resources] of chosen-node
  set intangible-resources (current-resources + other-resources) / 2
end

to update-dynamic-capabilities [chosen-node]
  let current-capabilities dynamic-capabilities
  let other-capabilities [dynamic-capabilities] of chosen-node
  set dynamic-capabilities (current-capabilities + other-capabilities) / 2
end

to update-strategic-management [chosen-node]
  let current-strategic-management strategic-management
  let other-strategic-management [strategic-management] of chosen-node
  set strategic-management (current-strategic-management + other-strategic-management) / 2
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

PLOT
673
15
1689
446
Overall Economic Growth Rate
Time
Economic growth rate over time
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Growth Rate" 1.0 0 -7500403 true "" ""
"Production" 1.0 0 -955883 true "" ""

BUTTON
35
49
98
82
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
36
105
100
138
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
12
176
199
209
technology-growth-rate
technology-growth-rate
0
1
0.06
0.01
1
NIL
HORIZONTAL

SLIDER
13
144
199
177
num-levels
num-levels
0
100
26.0
1
1
NIL
HORIZONTAL

INPUTBOX
12
242
199
302
business-it-alignment
1.0
1
0
Number

CHOOSER
16
326
154
371
network-type
network-type
"hierarchical" "flat" "matrix" "holacracy" "functional" "divisional" "hybrid"
1

@#$#@#$#@
## WHAT IS IT?
This model, "ODQ" (Organizational Dynamics Quantifier), simulates the dynamics of an organization's performance and its impact on overall economic growth. It considers various factors such as organizational network types, skill levels, resource constraints, technology growth, market competition, and business-IT alignment. The model explores the relationship between these factors and the organization's productivity, task completion, and human capital.
It is grounded in several scientific theories related to organizational behavior, network structures, and economic growth.

The following sections detail these theories modeled in the simulation.

1. Organizational Network Structures: The model incorporates seven different organizational network types (hierarchical, flat, matrix, holacracy, functional, divisional, and hybrid), each representing a specific way of organizing and managing the interactions between organizational members. These network structures are inspired by theories of organizational behavior and management, including contingency theory, which posits that the effectiveness of an organization depends on the fit between its structure and its environment.

2. Skill Acquisition and Learning: The model incorporates the concept of learning and skill acquisition based on the learning-rate parameter. This is in line with theories of human capital development and organizational learning, which suggest that the development of employees' skills and abilities is a critical factor in determining an organization's success.

3. Cobb-Douglas Production Function: The model uses a modified Cobb-Douglas production function to calculate the overall economic growth rate. The Cobb-Douglas production function is a widely-used neoclassical economic theory that models the relationship between output, capital, labor, and technology. In this model, the production function is extended to include human capital and market competition factors, allowing for a more comprehensive understanding of the factors that contribute to economic growth.

4. Social Exchange Theory: Social exchange theory suggests that relationships are built on the basis of the principle of reciprocity – the expectation that favors will be returned. 
    
5. Social Network Theory: Social network theory highlights the importance of the structure and dynamics of relationships among individuals or organizations.

6. Organizational Culture Theory: Organizational culture theory posits that shared values, beliefs, and practices shape the behavior of individuals within an organization.

7. Resource-Based View of the Firm: This perspective suggests that a firm's competitive advantage is derived from its unique resources and capabilities. In the model, we introduced tangible-resources and intangible-resources attributes to represent the resources each agent possesses. When agents interact, they exchange and combine their resources, leading to potential synergies and improved organizational performance. The resource-based-view-factor, a global variable, is incorporated into the production function to account for the impact of these unique resources on the organization's overall performance. Example: Suppose agent A has high tangible-resources (e.g., financial assets) while agent B has high intangible-resources (e.g., brand reputation). When they interact, they may share and combine these resources, potentially leading to new business opportunities and improved organizational performance.

8. Dynamic Capabilities: This concept refers to a firm's ability to adapt, integrate, and reconfigure its resources and capabilities in response to a changing environment. In the model, we introduced the dynamic-capabilities attribute to represent each agent's ability to adapt and respond to change. When agents interact, they exchange and learn from each other's dynamic capabilities, potentially enhancing their ability to adapt to changes and improve performance. Example: Consider agent A with strong dynamic capabilities in technology adaptation and agent B with strong dynamic capabilities in market sensing. As they interact, they may learn from each other and develop a more comprehensive understanding of their environment, enabling the organization to respond effectively to changes in the market or technology landscape.

9. Strategic Management: This concept encompasses the formulation and implementation of strategies to achieve organizational goals. In the model, we introduced the strategic-management attribute to represent each agent's ability to plan and execute strategies. When agents interact, they exchange and learn from each other's strategic management skills, potentially enhancing the organization's ability to formulate and implement effective strategies. Example: Agent A might have strong strategic management skills in product development, while agent B has strong skills in market expansion. As they interact, they can share their knowledge and insights, helping the organization to develop a more comprehensive and effective strategic plan.

10. Theory of Planned Behavior: This theory posits that an individual's intention to perform a specific behavior is influenced by their attitude, subjective norms, and perceived behavioral control.

11. Self-Determination Theory: This theory focuses on the role of intrinsic and extrinsic motivation in driving human behavior.

12. Motivation-Hygiene Theory: This theory distinguishes between factors that lead to job satisfaction (motivators) and those that lead to job dissatisfaction (hygiene factors). 


## HOW IT WORKS
The model consists of organizational members who interact with each other based on their network type (hierarchical, flat, matrix, holacracy, functional, divisional, or hybrid). The interactions between organizational members determine their alignment, which affects data quality, application usage, training, and skill level. Higher skill levels lead to increased productivity, while higher resource demand leads to resource constraints.

The production function takes into account capital, labor, technology, human capital, and market competition factors to calculate the overall economic growth rate. The simulation runs iteratively, updating the values at each step (tick) and plotting the results.

## HOW TO USE IT

1. Set the initial values for the sliders (num-org-members, num-levels, savings-rate, depreciation-rate, technology-growth-rate, alpha, rho, learning-rate, and market-competition-factor).
2. Choose the network type from the drop-down menu.
3. Press the "Setup" button to initialize the simulation with the chosen parameters.
4. Press the "Go" button to start the simulation. The model will run iteratively, updating the values and plotting the results.

Observe the plots for "Overall Economic Growth Rate," "Technology," and "Production" to analyze the impact of different factors on the organization's performance and economic growth.

## THINGS TO NOTICE
Pay attention to how different network types affect alignment, productivity, and task completion. Notice the impact of technology growth and market competition factors on overall economic growth rate and production.

FEEDBACK LOOPS
1. Feedback loop between productivity and skill level: This feedback loop is present in the model. As org-members improve their skills, their productivity increases, which is represented by the increase in the productivity attribute based on the skill-level. The model does not explicitly update the skill-level based on productivity, but it does consider the effect of learning rate, training, and resource constraints on skill development.

2. Feedback loop between technology and productivity: This feedback loop is present in the model as well. As technology improves (based on the technology-growth-rate parameter), it increases the productivity of org-members. The model captures the impact of technology on productivity through the Cobb-Douglas production function, where the production is influenced by the technology attribute.

3. Interdependency between data quality and application usage: This feedback loop is present in the model. The data-quality and application-usage attributes are influenced by the alignment attribute. As alignment increases, both data quality and application usage improve, capturing the interdependency between these factors.

4. Feedback loop between trust and collaboration: While the model does not explicitly include a trust attribute, it captures the concept of trust and collaboration through the alignment attribute. The alignment attribute represents the degree to which org-members are aligned in their goals and objectives, which can be influenced by trust and collaboration. As alignment improves, it positively impacts the org-members' task completion and productivity.

5. Interdependency between communication-channel and collaboration-tool: The model does not explicitly include communication channels or collaboration tools as attributes. However, their effects can be implicitly captured through the organizational network structures (e.g., hierarchical, flat, matrix, etc.), which represent different ways org-members interact and communicate. The impact of communication channels and collaboration tools on productivity and task completion could be explored by adjusting the network structure and alignment attributes in the model.

6. Higher skill levels lead to increased productivity. As organizational members improve their skills, they become more productive, contributing to the organization's performance and overall economic growth. For example, an employee with a higher skill level in data analysis can process information more efficiently, leading to faster and more accurate decision-making.

7. Higher resource demand leads to resource constraints. As the sum of skill levels of all organizational members increases, it places a higher demand on resources (e.g., budget, time, and equipment). This increased demand creates resource constraints, which in turn limit the rate at which organizational members can continue to develop their skills. For example, if an organization has limited budget and resources, it may not be able to provide sufficient training opportunities for all employees, leading to slower skill development.

ADAPTIVE AGENTS
The agents in this model, represented as org-members, are adaptive. They adapt to their environment based on their interactions with other agents, resource constraints, and other factors.

For example, the model adapts to changes in the following ways:

1. Alignment update: The agents adapt their alignment based on the interactions with other agents, depending on the organizational network type (hierarchical, flat, matrix, etc.). As a result, the alignment attribute is updated in response to the agent's environment and interactions.

2. Skill level update: The agents adapt their skill levels based on their learning rate, training, and resource constraints. This adaptation is captured by the skill-level attribute, which is updated during the simulation.

3. Productivity update: The agents adapt their productivity based on their skill level. As their skill level increases, their productivity also improves. This adaptation is captured through the updates to the productivity attribute during the simulation.

These adaptations allow agents to respond to their environment and the changing conditions within the model, reflecting the dynamic nature of organizational structures and economic growth.


## THINGS TO TRY
1. Experiment with different network types and observe their impact on organizational performance.
2. Modify the parameters such as technology-growth-rate or market-competition-factor and analyze how they influence the economic growth rate.
3. Adjust the learning rate or the number of organizational members and observe how it affects skill levels and productivity.

## EXTENDING THE MODEL
1. Consider including other factors that may affect organizational performance, such as employee motivation or job satisfaction.
2. Investigate the impact of different leadership styles on the organization's performance and overall economic growth.
3. Implement additional network types or customize the existing ones to better represent specific organizational structures.


## NETLOGO FEATURES
The model demonstrates the use of agent-based modeling to represent organizational members, their interactions, and network types. It showcases the use of conditional statements, agentsets, and mathematical operations to calculate various factors and their impact on the organization's performance and economic growth.


## RELATED MODELS



## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Organizational Solow Model Experiment" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>"overall_economic_growth_rate"</metric>
    <metric>"technology"</metric>
    <metric>"production"</metric>
    <enumeratedValueSet variable="network-type">
      <value value="&quot;hierarchical&quot;"/>
      <value value="&quot;flat&quot;"/>
      <value value="&quot;matrix&quot;"/>
      <value value="&quot;holacracy&quot;"/>
      <value value="&quot;functional&quot;"/>
      <value value="&quot;divisional&quot;"/>
      <value value="&quot;hybrid&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rho">
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-competition-factor">
      <value value="0.5"/>
      <value value="0.75"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="technology-growth-rate">
      <value value="0.01"/>
      <value value="0.02"/>
      <value value="0.03"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
