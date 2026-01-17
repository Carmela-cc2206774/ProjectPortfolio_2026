import Link from "next/link";
import "./globals.css";

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <head>
        <link
          rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
        />
      </head>
      <body className={"shell-body"}>
        <nav className="shell-nav">
          <h2>NutriSnap</h2>
          <ul>
            <li>
              <Link className="nav-link" href="/">
                Home
              </Link>
              <Link className="nav-link" href="/addUpdate">
                Add Meal
              </Link>
              <Link className="nav-link" href="/summary">
                Summary
              </Link>
            </li>
          </ul>
        </nav>

        <main className="container">{children}</main>
        <footer>NutriSnap © 2025</footer>
      </body>
    </html>
  );
}
