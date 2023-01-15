# Mock_tradex

<div align="grid">
<h1>Graph Screen</h1>
<img src="https://user-images.githubusercontent.com/79362508/212535847-d3c83abe-44eb-402f-9e32-c630292013f2.jpg" width=300 >
<h1>Exchange</h1>
<img src="https://user-images.githubusercontent.com/79362508/212535850-06987aa4-8b88-4bde-a3ff-376e1dc17d71.jpg" width=300 >
<h1>News</h1>
<img src="https://user-images.githubusercontent.com/79362508/212535846-bfc9e793-ee0d-4e6d-bce3-6b60bdcd2668.jpg" width=300 >
<h1>Trade</h1>
<img src="https://user-images.githubusercontent.com/79362508/212535845-1c79a019-d372-4250-a599-bcbc04086f41.jpg" width=300 >
<h1>Index</h1>
<img src="https://user-images.githubusercontent.com/79362508/212535844-219d3dd3-624a-4c0f-876f-2fd27074b5b2.jpg" width=300 >
<h1>Login</h1>
<img src="https://user-images.githubusercontent.com/79362508/212535842-269e1a7c-66fb-4d79-9dbd-5bc405524f60.jpg" width=300 >
</div>




A new Flutter project.

## Get Your Copy 

- Fork this repo
- Clone the repo

## Getting Started

### Understanding the lib folder:

1. Presentation Folder -> this folder will contain all the code for screen UI (in Presentation/Screen Folder) and some common widgets (under Presentation/Widgets Folder).

2. Buisness_Logic Folder -> This Folder will have all the logical components of our application. BLOC will be used for state management purpose.

3. Data Folder -> This Folder contains Data_Provider, Models and Repositories as subFolder.
  
  - Data_Provider encapsulates all the source files from where data needs to be fetched like an API, or from Database

  - Repositories transforms the data fetched by Data_Provider into a model using the Models made in Model Folder.

## WorkFlow

- Presentation Layer asks for any sort of Data From Buisness_Logic Layer which in turn Send this request to Data Layer

- Here, Under Data layer Repositories Folder models the data fetched by data_provider layer and sends back to Buisness_logic layer which is returned to Presentation Layer which then gets rendered on the screen.

## Local Clone Setup

- After Cloning this repo into your local system
- Create a branch from master and switch into it - git checkout -b your-name/feature-name (eg: git checkout -b sahil/building_HomeScreen)
- it needs to be kept in your mind no code should be commited on the master branch.
- do your work in your feature branch.
- once done, add all changes using this command --> git add .
- then run: git commit -m "short description of your work"
- git push origin master
- Create a PR


