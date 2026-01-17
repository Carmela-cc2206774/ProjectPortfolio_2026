// URL====================================================================================
const BASE_URL =
  "https://gist.githubusercontent.com/abdalabaaji/8ac1f0ff9c9e919c72c5f297a9b5266e/raw/a67887ba7445a6887be4c748fcfa0931f0dd165c/recipes";

// SELECTORS==============================================================================
const recipesContainer = document.getElementById("recipes");
const mainContentContainer = document.getElementById("main-content");
const deleteButton = document.querySelector(".btn-delete");

// ADD ITEM==============================================================================
async function loadPage(pageUrl, opt, index) {
  const page = await fetch(pageUrl);
  const pageHTMLContent = await page.text();
  mainContentContainer.innerHTML = pageHTMLContent;

  if (!opt) {
    const r = recipes[index];
    document.getElementById("recipe-name").value = r.name;
    document.getElementById("recipe-img").value = r.image;
    document.getElementById("recipe-ingredients").value = r.ingredients;
    document.getElementById("recipe-instructions").value = r.instructions;
    document.getElementById("add-recipe-btn").value = "Update Recipe";
  }

  if (document.querySelector("#add-recipe-form")) {
    const form = document.querySelector("#add-recipe-form");
    form.addEventListener("submit", (e) => handleSubmit(e, opt, index));
  }
}

let recipes = localStorage.recipes ? JSON.parse(localStorage.recipes) : [];

function handleSubmit(e, opt, index) {
  e.preventDefault();
  const observedData = new FormData(e.target);
  const recipe = Object.fromEntries(observedData);
  if (opt) {
    setId(recipe);
  }
  addUpdateRecipe(recipe, opt, index);
}

function setId(recipe) {
  recipe.id = parseInt(localStorage.idAccumulator) + 1;
  localStorage.idAccumulator = recipe.id;
  console.log(`current id acc = ${localStorage.idAccumulator}`);
}

//   true - add   false - update
function addUpdateRecipe(recipe, opt, index) {
  if (opt) {
    recipes.push({
      id: recipe["id"],
      image: recipe["recipe-img"],
      ingredients: recipe["recipe-ingredients"],
      instructions: recipe["recipe-instructions"],
      name: recipe["recipe-name"],
    });
  } else {
    recipes[index].image = recipe["recipe-img"];
    recipes[index].ingredients = recipe["recipe-ingredients"];
    recipes[index].instructions = recipe["recipe-instructions"];
    recipes[index].name = recipe["recipe-name"];
  }
  localStorage.recipes = JSON.stringify(recipes);
  window.location.reload();
}

// LOAD HOME PAGE==============================================================================
document.addEventListener("DOMContentLoaded", () => {
  loadRecipes();
});

async function loadRecipes() {
  let recipes;
  if (localStorage.recipes) {
    recipes = JSON.parse(localStorage.recipes);
    console.log("...recipes loaded from local storage...");
  } else {
    const response = await fetch(BASE_URL);
    recipes = await response.json();
    localStorage.recipes = JSON.stringify(recipes);
    console.log("...recipes loaded from api...");
  }

  localStorage.idAccumulator = recipes[recipes.length - 1].id;
  console.log(`current id acc = ${localStorage.idAccumulator}`);

  renderRecipes(recipes);
  console.log(recipes);
}

const renderRecipes = (recipes) =>
  (recipesContainer.innerHTML = recipes
    .map((r, index) => convertToCard(r, index))
    .join(""));

const convertToCard = (r, index) => `
            <div class="recipe-card">
                <img src="${r.image}" class="card-img" />
                <div class="description">
                    <h1>${r.name}</h1>
                    <hr>
                    <h2>Instructions</h2>
                    <p class="instructions">
                    ${r.instructions}
                    </p>
                </div>
                <div class="action-btns">
                    <button class="btn-update" onclick="loadPage('edit_page.html',false, ${index})"> <i class="fa fa-pencil">Update</i></button>
                    <button class="btn-delete" onclick="deleteRecipe(${index})">  <i class="fa fa-trash"> Delete </i></button>
                </div>
            </div>
`;

// DELETE ITEM==============================================================================
function deleteRecipe(index) {
  recipes.splice(index, 1);
  localStorage.recipes = JSON.stringify(recipes);
  loadRecipes();
}

// // UPDATE ITEM==============================================================================
// async function loadUpdate(index){
//     const page = await fetch('edit_page.html');
//     const pageHTMLContent = await page.text();
//     mainContentContainer.innerHTML = pageHTMLContent;

//     const recipeToEdit = recipes[index];

//     if (document.querySelector("#add-recipe-form")) {
//       const form = document.querySelector("#add-recipe-form");
//       form.addEventListener("submit", handleUpdateSubmit);
//     }
// }

// function handleUpdateSubmit(e) {

// }
