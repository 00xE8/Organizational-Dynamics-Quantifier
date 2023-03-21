# Organizational-Dynamics-Quantifier
This model, “ODQ” (Organizational Dynamics Quantifier), simulates the dynamics of an organization’s performance and its impact on overall economic growth. It considers various factors such as organizational network types, skill levels, resource constraints, technology growth, market competition, and business-IT alignment.The model explores the relationship between these factors and the organization’s productivity, task completion, and human capital. It is grounded in several scientific theories related to organizational behavior, network structures, and economic growth.

The following sections detail these theories modeled in the simulation.
Organizational Network Structures: The model incorporates seven different organizational network types (hierarchical, flat, matrix, holacracy, functional, divisional, and hybrid), each representing a specific way of organizing and managing the interactions between organizational members. These network structures are inspired by theories of organizational behavior and management, including contingency theory, which posits that the effectiveness of an organization depends on the fit between its structure and its environment.

Skill Acquisition and Learning: The model incorporates the concept of learning and skill acquisition based on the learning-rate parameter. This is in line with theories of human capital development and organizational learning, which suggest that the development of employees’ skills and abilities is a critical factor in determining an organization’s success.

Cobb-Douglas Production Function: The model uses a modified Cobb-Douglas production function to calculate the overall economic growth rate. The Cobb-Douglas production function is a widely-used neoclassical economic theory that models the relationship between output, capital, labor, and technology. In this model, the production function is extended to include human capital and market competition factors, allowing for a more comprehensive understanding of the factors that contribute to economic growth.

Social Exchange Theory: Social exchange theory suggests that relationships are built on the basis of the principle of reciprocity – the expectation that favors will be returned.
Social Network Theory: Social network theory highlights the importance of the structure and dynamics of relationships among individuals or organizations.

Organizational Culture Theory: Organizational culture theory posits that shared values, beliefs, and practices shape the behavior of individuals within an organization.

Resource-Based View of the Firm: This perspective suggests that a firm’s competitive advantage is derived from its unique resources and capabilities. In the model, we introduced tangible-resources and intangible-resources attributes to represent the resources each agent possesses. When agents interact, they exchange and combine their resources, leading to potential synergies and improved organizational performance. The resource-based-view-factor, a global variable, is incorporated into the production function to account for the impact of these unique resources on the organization’s overall performance. Example: Suppose agent A has high tangible-resources (e.g., financial assets) while agent B has high intangible-resources (e.g., brand reputation). When they interact, they may share and combine these resources, potentially leading to new business opportunities and improved organizational performance.

Dynamic Capabilities: This concept refers to a firm’s ability to adapt, integrate, and reconfigure its resources and capabilities in response to a changing environment. In the model, we introduced the dynamic-capabilities attribute to represent each agent’s ability to adapt and respond to change. When agents interact, they exchange and learn from each other’s dynamic capabilities, potentially enhancing their ability to adapt to changes and improve performance. Example: Consider agent A with strong dynamic capabilities in technology adaptation and agent B with strong dynamic capabilities in market sensing. As they interact, they may learn from each other and develop a more comprehensive understanding of their environment, enabling the organization to respond effectively to changes in the market or technology landscape.

Strategic Management: This concept encompasses the formulation and implementation of strategies to achieve organizational goals. In the model, we introduced the strategic-management attribute to represent each agent’s ability to plan and execute strategies. When agents interact, they exchange and learn from each other’s strategic management skills, potentially enhancing the organization’s ability to formulate and implement effective strategies. Example: Agent A might have strong strategic management skills in product development, while agent B has strong skills in market expansion. As they interact, they can share their knowledge and insights, helping the organization to develop a more comprehensive and effective strategic plan.

Theory of Planned Behavior: This theory posits that an individual’s intention to perform a specific behavior is influenced by their attitude, subjective norms, and perceived behavioral control.

Self-Determination Theory: This theory focuses on the role of intrinsic and extrinsic motivation in driving human behavior.

Motivation-Hygiene Theory: This theory distinguishes between factors that lead to job satisfaction (motivators) and those that lead to job dissatisfaction (hygiene factors).

HOW IT WORKS
The model consists of organizational members who interact with each other based on their network type (hierarchical, flat, matrix, holacracy, functional, divisional, or hybrid). The interactions between organizational members determine their alignment, which affects data quality, application usage, training, and skill level. Higher skill levels lead to increased productivity, while higher resource demand leads to resource constraints.
The production function takes into account capital, labor, technology, human capital, and market competition factors to calculate the overall economic growth rate. The simulation runs iteratively, updating the values at each step (tick) and plotting the results.

HOW TO USE IT
Set the initial values for the sliders (num-org-members, num-levels, savings-rate, depreciation-rate, technology-growth-rate, alpha, rho, learning-rate, and market-competition-factor).
Choose the network type from the drop-down menu.
Press the “Setup” button to initialize the simulation with the chosen parameters.
Press the “Go” button to start the simulation. The model will run iteratively, updating the values and plotting the results.
Observe the plots for “Overall Economic Growth Rate,” “Technology,” and “Production” to analyze the impact of different factors on the organization’s performance and economic growth.

THINGS TO NOTICE
Pay attention to how different network types affect alignment, productivity, and task completion. Notice the impact of technology growth and market competition factors on overall economic growth rate and production.
FEEDBACK LOOPS 1. Feedback loop between productivity and skill level: This feedback loop is present in the model. As org-members improve their skills, their productivity increases, which is represented by the increase in the productivity attribute based on the skill-level. The model does not explicitly update the skill-level based on productivity, but it does consider the effect of learning rate, training, and resource constraints on skill development.
Feedback loop between technology and productivity: This feedback loop is present in the model as well. As technology improves (based on the technology-growth-rate parameter), it increases the productivity of org-members. The model captures the impact of technology on productivity through the Cobb-Douglas production function, where the production is influenced by the technology attribute.
Interdependency between data quality and application usage: This feedback loop is present in the model. The data-quality and application-usage attributes are influenced by the alignment attribute. As alignment increases, both data quality and application usage improve, capturing the interdependency between these factors.

Feedback loop between trust and collaboration: While the model does not explicitly include a trust attribute, it captures the concept of trust and collaboration through the alignment attribute. The alignment attribute represents the degree to which org-members are aligned in their goals and objectives, which can be influenced by trust and collaboration. As alignment improves, it positively impacts the org-members’ task completion and productivity.
Interdependency between communication-channel and collaboration-tool: The model does not explicitly include communication channels or collaboration tools as attributes. However, their effects can be implicitly captured through the organizational network structures (e.g., hierarchical, flat, matrix, etc.), which represent different ways org-members interact and communicate. The impact of communication channels and collaboration tools on productivity and task completion could be explored by adjusting the network structure and alignment attributes in the model.

Higher skill levels lead to increased productivity. As organizational members improve their skills, they become more productive, contributing to the organization’s performance and overall economic growth. For example, an employee with a higher skill level in data analysis can process information more efficiently, leading to faster and more accurate decision-making.

Higher resource demand leads to resource constraints. As the sum of skill levels of all organizational members increases, it places a higher demand on resources (e.g., budget, time, and equipment). This increased demand creates resource constraints, which in turn limit the rate at which organizational members can continue to develop their skills. For example, if an organization has limited budget and resources, it may not be able to provide sufficient training opportunities for all employees, leading to slower skill development.

ADAPTIVE AGENTS
The agents in this model, represented as org-members, are adaptive. They adapt to their environment based on their interactions with other agents, resource constraints, and other factors.
For example, the model adapts to changes in the following ways:
Alignment update: The agents adapt their alignment based on the interactions with other agents, depending on the organizational network type (hierarchical, flat, matrix, etc.). As a result, the alignment attribute is updated in response to the agent’s environment and interactions.
Skill level update: The agents adapt their skill levels based on their learning rate, training, and resource constraints. This adaptation is captured by the skill-level attribute, which is updated during the simulation.
Productivity update: The agents adapt their productivity based on their skill level. As their skill level increases, their productivity also improves. This adaptation is captured through the updates to the productivity attribute during the simulation.
These adaptations allow agents to respond to their environment and the changing conditions within the model, reflecting the dynamic nature of organizational structures and economic growth.

THINGS TO TRY
Experiment with different network types and observe their impact on organizational performance.
Modify the parameters such as technology-growth-rate or market-competition-factor and analyze how they influence the economic growth rate.
Adjust the learning rate or the number of organizational members and observe how it affects skill levels and productivity.

EXTENDING THE MODEL
Consider including other factors that may affect organizational performance, such as employee motivation or job satisfaction.
Investigate the impact of different leadership styles on the organization’s performance and overall economic growth.
Implement additional network types or customize the existing ones to better represent specific organizational structures.

NETLOGO FEATURES
The model demonstrates the use of agent-based modeling to represent organizational members, their interactions, and network types. It showcases the use of conditional statements, agentsets, and mathematical operations to calculate various factors and their impact on the organization’s performance and economic growth.
RELATED MODELS

CREDITS AND REFERENCES
(a reference to the model’s URL on the web if it has one, as well as any other necessary credits, citations, and links)
