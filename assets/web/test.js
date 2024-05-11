// // <!-- <html lang="en">
// // <head>
// //   <meta charset="UTF-8">
// //   <meta name="viewport" content="width=device-width, initial-scale=1.0">
// //   <title>Test Page</title>
// // </head>
// // <body>
// //   <h1 id="title">Hello, Flutter!</h1>
// //   <button id="changeTitleButton">Change Title</button>

// //   <script>
// //     document.addEventListener('DOMContentLoaded', () => {
// //       const titleElement = document.getElementById('title');
// //       const changeTitleButton = document.getElementById('changeTitleButton');

// //       changeTitleButton.addEventListener('click', () => {
// //         titleElement.textContent = 'Title Changed!';
// //       });
// //     });
// //   </script>
// // </body>
// // </html> -->
// // <!-- index.html -->
// // <!DOCTYPE html>
// <html lang="en">
// <head>
//   <meta charset="UTF-8">
//   <meta name="viewport" content="width=device-width, initial-scale=1.0">
//   <title>GLB Viewer</title>
//   <style>
//     body {
//       margin: 0;
//       background-color: #f0f0f0;
//     }
//     #canvas {
//       width: 100%;
//       height: 100vh;
//       display: block;
//     }
//     #textfield {
//       position: absolute;
//       top: 10px;
//       left: 10px;
//       z-index: 1;
//     }
//   </style>
// </head>
// <body>
//   <canvas id="canvas"></canvas>
//   <input id="textfield" type="text" placeholder="Enter some text">
//   <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
//   <script>
//     const canvas = document.getElementById('canvas');
//     const textfield = document.getElementById('textfield');
//     const scene = new THREE.Scene();
//     const camera = new THREE.PerspectiveCamera(75, canvas.width / canvas.height, 0.1, 1000);
//     const renderer = new THREE.WebGLRenderer({
//       canvas: canvas,
//       antialias: true
//     });
//     renderer.setSize(canvas.width, canvas.height);

//     // Load the GLB file
//     const loader = new THREE.GLTFLoader();
//     loader.load('model.glb', (gltf) => {
//       scene.add(gltf.scene);
//       animate();
//     });

//     function animate() {
//       requestAnimationFrame(animate);
//       renderer.render(scene, camera);
//     }
//   </script>
// </body>
// </html>
// index.js
import * as THREE from 'https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.module.js';

const canvas = document.createElement('canvas');
document.body.appendChild(canvas);

const textfield = document.createElement('input');
textfield.type = 'text';
textfield.placeholder = 'Enter some text';
document.body.appendChild(textfield);

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(75, canvas.width / canvas.height, 0.1, 1000);
const renderer = new THREE.WebGLRenderer({
  canvas: canvas,
  antialias: true
});
renderer.setSize(canvas.width, canvas.height);

// Load the GLB file
const loader = new THREE.GLTFLoader();
loader.load('model.glb', (gltf) => {
  scene.add(gltf.scene);
  animate();
});

function animate() {
  requestAnimationFrame(animate);
  renderer.render(scene, camera);
}

// Add some basic styling
canvas.style.width = '100%';
canvas.style.height = '100vh';
canvas.style.display = 'block';
textfield.style.position = 'absolute';
textfield.style.top = '10px';
textfield.style.left = '10px';
textfield.style.zIndex = '1';