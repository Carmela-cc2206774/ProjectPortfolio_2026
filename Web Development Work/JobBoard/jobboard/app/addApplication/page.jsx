"use client";

import Link from "next/link";
import { addApplicationAction } from "../actions/server-actions";
import { useSearchParams } from "next/navigation";
// useSearchParams

export default function AddApplication() {
    
  const searchParams = useSearchParams();
  const job = Object.fromEntries(searchParams);

  return (
    <>
      <div className="job-details" id={job.id}>
        <h2>You are applying to: {job.title}</h2>
        <div className="job-meta">
          <div className="job-info">
            <i className="fas fa-building"></i>
            <span>{job.company}</span>
          </div>
          <div className="job-info">
            <i className="fas fa-map-marker-alt"></i>
            <span>{job.location}</span>
          </div>
          <div className="job-info">
            <i className="fas fa-briefcase"></i>
            <span>{job.type}</span>
          </div>
          <div className="job-info">
            <i className="fas fa-money-bill-wave"></i>
            <span>{job.salary}</span>
          </div>
        </div>
        <div className="job-description">
          <h3>Job Description</h3>
          <p>{job.description}</p>
        </div>
      </div>

      <div className="application-form-container">
        <div className="form-actions">
          <Link href={"/"}>
            <button className="btn btn-secondary">
              <i className="fas fa-arrow-left"></i> Back to Jobs
            </button>
          </Link>
        </div>
        <form className="application-form" action={addApplicationAction}>
          <input type="hidden" name="jobId" id="jobId" defaultValue={job.id} />
          <div className="form-group">
            <label htmlFor="name">Full Name</label>
            <input type="text" id="name" name="name" required></input>
          </div>
          <div className="form-group">
            <label htmlFor="email">Email</label>
            <input type="email" id="email" name="email" required></input>
          </div>
          <div className="form-group">
            <label htmlFor="resume">Resume Link</label>
            <input type="url" id="resume" name="resume" required></input>
          </div>
          <button type="submit" className="btn btn-primary">
            Submit Application
          </button>
        </form>
      </div>
    </>
  );
}
