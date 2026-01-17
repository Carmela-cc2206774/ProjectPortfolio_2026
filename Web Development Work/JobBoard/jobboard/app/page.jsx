"use client";

import Image from "next/image";
import styles from "./page.module.css";
import { useEffect, useState } from "react";
import {
  getJobsAction,
} from "./actions/server-actions";
import Link from "next/link";

export default function Home() {
  const [jobs, setJobs] = useState([]);
  const [isActiveOnly, setIsActiveOnly] = useState(false);

  useEffect(() => {
    fetchJobs(isActiveOnly);
  }, [isActiveOnly]);

  async function fetchJobs(isActiveOnly) {
    const j = await getJobsAction(isActiveOnly);
    setJobs(j);
  }

  // async function applicationCount(jobId) {
  //   const count = await getApplicationsCountAction(jobId);

  //   return count;
  // }

  // async function handleToggle(status){
  //   setIsActiveOnly(!status)
  // }

  return (
    <>
      <div className="container">
        <div className="filters">
          <label className="toggle">
            <input
              type="checkbox"
              id="showActiveOnly"
              onClick={() => setIsActiveOnly(!isActiveOnly)}
            ></input>
            <span className="slider"></span>
            Show Active Jobs Only
          </label>
        </div>
        <div className="jobs-grid">
          {/* grid ! */}

          {jobs.map((job, key) => (
            <div
              key={key}
              className={`job-card ${!job.isActive ? "job-inactive" : ""}`}
              data-job-id={job.id}
            >
              <div className="job-header">
                <div>
                  <h3 className="job-title">{job.title}</h3>
                  <div className="job-info">
                    <i className="fas fa-building"></i>
                    <span>{job.company}</span>
                  </div>
                  <div className="job-info">
                    <i className="fas fa-map-marker-alt"></i>
                    <span>{job.location}</span>
                  </div>
                </div>
                <span className="status-badge ${!job.isActive ? 'status-inactive' : ''}">
                  {job.isActive ? "Active" : "Inactive"}
                </span>
              </div>
              <div className="job-info">
                <i className="fas fa-briefcase"></i>
                <span>{job.type}</span>
              </div>
              <div className="job-info">
                <i className="fas fa-money-bill-wave"></i>
                <span>{job.salary}</span>
              </div>
              <div className="job-actions">
                <div className="application-count">
                  <i className="fas fa-users"></i>
                  <span className="count">{job.applications.length}</span>
                  <span>applications</span>
                </div>

                {job.isActive ? (
                  <Link
                    href={{ pathname: "/addApplication", query: { ...job } }}
                    className="btn btn-primary"
                  >
                    Apply Now
                  </Link>
                ) : (
                  ""
                )}
              </div>
            </div>
          ))}
        </div>
      </div>
    </>
  );
}
