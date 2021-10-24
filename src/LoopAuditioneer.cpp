/*
 * LoopAuditioneer is a tool for evaluating loops (and cues) in wav files
 * especially useful for samples intended for organ samplesets
 * Copyright (C) 2011-2021 Lars Palo 
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * You can contact the author on larspalo(at)yahoo.se
 */

#include "LoopAuditioneer.h"
#include "LoopAuditioneerDef.h"

#if 0
#include <wx/fs_zip.h>
#else
#include "resources/application/help.zip.h"
#include <wx/fs_arc.h>
#include <wx/fs_mem.h>
#endif

#include <wx/image.h>
#include <wx/xrc/xmlres.h>

IMPLEMENT_APP(LoopAuditioneerApp)

// This initializes the application
bool LoopAuditioneerApp::OnInit() {

  // Initialize all needed handlers
  wxImage::AddHandler(new wxPNGHandler);
  wxImage::AddHandler(new wxJPEGHandler);
#if 0
  wxFileSystem::AddHandler(new wxZipFSHandler);
#else
  wxFileSystem::AddHandler( new wxArchiveFSHandler );
  wxFileSystem::AddHandler( new wxMemoryFSHandler );
  wxMemoryFSHandler::AddFileWithMimeType("help.zip", help_zip, sizeof(help_zip), "application/zip");
#endif
  extern void InitXmlResource(); // defined in generated file
  wxXmlResource::Get()->InitAllHandlers();
  InitXmlResource();

  // Create the frame window
  wxString fullAppName = wxEmptyString;
  fullAppName.Append(appName);
  fullAppName.Append(wxT(" "));
  fullAppName.Append(appVersion);
  frame = new MyFrame(fullAppName);

  frame->SetWindowStyle(wxDEFAULT_FRAME_STYLE | wxWANTS_CHARS);

  // the help controller
  m_helpController = new wxHtmlHelpController();
#if 0
  m_helpController->AddBook(wxFileName("help/help.zip"));
#else
  m_helpController->AddBook("memory:help.zip");
#endif
  m_helpController->SetFrameParameters(wxT("%s"), wxDefaultSize, wxDefaultPosition);

  // load icons
  m_icons = wxIconBundle(wxXmlResource::Get()->LoadIcon("loopy16"));
  m_icons.AddIcon(wxXmlResource::Get()->LoadIcon("loopy24"));
  m_icons.AddIcon(wxXmlResource::Get()->LoadIcon("loopy32"));
  m_icons.AddIcon(wxXmlResource::Get()->LoadIcon("loopy48"));

  frame->SetIcons(m_icons);

  // Show the frame
  frame->Show(true);

  // Start the event loop
  return true;
}

int LoopAuditioneerApp::OnExit() {
  delete m_helpController;
  return wxApp::OnExit();
}

